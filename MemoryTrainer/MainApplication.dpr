program MainApplication;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Windows,
  System.StrUtils;

type
  TDictionary = array [1 .. 4] of array of string;
  TSetOfWords = array [1 .. 8] of string;

procedure LoadDictionary(var words: TDictionary);
var
  fileVar: TextFile;
  files: array [1 .. 4] of string;
  count: integer;
  i, k: integer;
  line: string;
begin
  // ������������� � ���������� ���������, ������� ������������ � �������� �����
  files[1] := '..\..\..\dictionaries\words5.txt';
  files[2] := '..\..\..\dictionaries\words6.txt';
  files[3] := '..\..\..\dictionaries\words7.txt';
  files[4] := '..\..\..\dictionaries\words8.txt';

  for i := 1 to 4 do
  begin
    // �������� ����� � ������ ������
    AssignFile(fileVar, files[i]);
    Reset(fileVar);

    // ������ ������ ������, ��� �������� ���������� ����, ���������� �� � ��� integer � ��������� ����� ������������� �������
    readln(fileVar, line);
    count := StrToInt(line);
    SetLength(words[i], count);
    k := 0;

    // ���������� ������ � ������
    while (not EOF(fileVar)) do
    begin
      readln(fileVar, line);
      words[i][k] := line;
      inc(k);
    end;
    CloseFile(fileVar);
  end;
end;

procedure ClearScreen();
var
  ConsoleSize, NumWritten: LongWord;
  Origin: Coord;
  ScreenBufferInfo: CONSOLE_SCREEN_BUFFER_INFO;
  hStdOut: THandle;
begin
  hStdOut := GetStdHandle(STD_OUTPUT_HANDLE);
  GetConsoleScreenBufferInfo(hStdOut, ScreenBufferInfo);
  ConsoleSize := ScreenBufferInfo.dwSize.X * ScreenBufferInfo.dwSize.Y;
  Origin.X := 0;
  Origin.Y := 0;
  FillConsoleOutputCharacter(hStdOut, ' ', ConsoleSize, Origin, NumWritten);
  FillConsoleOutputAttribute(hStdOut, ScreenBufferInfo.wAttributes, ConsoleSize,
    Origin, NumWritten);
  SetConsoleCursorPosition(hStdOut, Origin);
end;

procedure TrimString(var str: string);
const
  doubleSpace = '  ';
begin
  str := Trim(str);
  while Pos(doubleSpace, str) <> 0 do
    Delete(str, Pos(doubleSpace, str), 1);
end;

function IsValid(checkStr: string): byte;
var
  i, number: integer;
  flag: boolean;
  value: byte;
begin
  flag := true;
  value := $00;
  if Length(checkStr) = 0 then
    value := $01
  else
  begin
    for i := 1 to Length(checkStr) do
    begin
      number := Ord(checkStr[i]);
      if not (((number >= 1040) and (number <= 1071)) or (number = 32)) then
        flag := false;
    end;
    if not flag then
      value := $10
    else
      value := $00;
  end;
  Result := value;
end;

function RandomArr(words: TDictionary; numberOfWords: byte): TSetOfWords;
var
  arrTemp: TSetOfWords;
  rIndex: word;
begin
  Randomize;
  for var i := 1 to 8 do
    arrTemp[i] := '';
  for var j := 1 to numberOfWords do
  begin
    rIndex := random(4) + 1;
    arrTemp[j] := words[rIndex][random(Length(words[rIndex]))];
  end;
  Result := arrTemp;
end;

function IsValidS1(stageStr, userStr: string): boolean;
begin
  stageStr := ReverseString(stageStr);
  if stageStr = userStr then
    Result := true
  else
    Result := false;
end;

function IsValidS2(stageArr: TSetOfWords; numOfWords: byte;
  userStr: string): boolean;
const
  space = ' ';
var
  checkWord: string;
  i: byte;
  flag: boolean;
begin
  flag := true;
  userStr := Concat(space, userStr, space);

  for i := 1 to numOfWords do
  begin
    checkWord := stageArr[i];
    checkWord := Concat(space, checkWord, space);
    if Pos(checkWord, userStr) = 0 then
    begin
      flag := false;
      break;
    end
    else
      Delete(userStr, Pos(checkWord, userStr), Length(checkWord) - 1);
  end;
  Result := flag;
end;

function IsValidS3(stageArr: TSetOfWords; numOfWords: byte;
  userStr: string): boolean;
const
  space = ' ';
var
  checkString: string;
begin
  checkString := String.Join(space, stageArr, 0, numOfWords);
  if checkString = userStr then
    Result := true
  else
    Result := false;
end;

function IsValidS4(stageArr: TSetOfWords; numOfWords: byte;
  userStr: string): boolean;
const
  space = ' ';
var
  i: byte;
  checkWord: string;
  flag: boolean;
begin
  for i := 1 to numOfWords do
    stageArr[i] := ReverseString(stageArr[i]);
  userStr := Concat(space, userStr, space);

  flag := true;
  for i := 1 to numOfWords do
  begin
    checkWord := stageArr[i];
    checkWord := Concat(space, checkWord, space);
    if Pos(checkWord, userStr) = 0 then
    begin
      flag := false;
      break;
    end
    else
      Delete(userStr, Pos(checkWord, userStr), Length(checkWord) - 1);
  end;
  Result := flag;

end;

function IsValidS5(stageArr: TSetOfWords; numOfWords: byte;
  userStr: string): boolean;
const
  space = ' ';
var
  i: integer;
  temp, checkString: string;
begin
  checkString := String.Join(space, stageArr, 0, numOfWords);
  checkString := ReverseString(checkString);
  if checkString = userStr then
    Result := true
  else
    Result := false;
end;

procedure Stage1(words: TDictionary);
var
  level, counter: integer;
  stageStr, inputStr: string;
begin
  Randomize;
  stageStr := '';
  inputStr := '';
  level := 1;

  while level <= 4 do
  begin
    counter := 0;
    while counter < 3 do
    begin
      stageStr := words[level][random(Length(words[level]))];

      writeln('���� 1. ������� ', level);
      writeln(stageStr);
      sleep(3000);
      ClearScreen();

      writeln('���� 1. ������� ', level, #13#10, '������� ����������� �����:');

      repeat
        readln(inputStr);
        TrimString(inputStr);
        inputStr := AnsiUpperCase(inputStr);
        case IsValid(inputStr) of
          $01:
            writeln('������ ������. ��������� ����.');
          $10:
            writeln('������������ ����. ��������� ����.');
        end;
      until IsValid(inputStr) = $00;

      if IsValidS1(stageStr, inputStr) = False then
      begin
        writeln('����� ��������! ���������� ��� ���.');
        counter := 0;
        writeln('��������: ', counter, ' �� 3.');
      end
      else
      begin
        writeln('����� ������!');
        inc(counter);
        writeln('��������: ', counter, ' �� 3.');
      end;

      writeln('������� Enter, ����� ����������.');
      readln;
      ClearScreen();
    end;
    Inc(level);
  end;
  writeln('�� ������ ���� 1! �����������!');
  writeln('������� Enter, ����� ������� � ���������� �����.');
  readln;
  ClearScreen;
end;

procedure Stage2(words: TDictionary);
var
  level, counter: integer;
  inputStr: string;
  stageArr: TSetOfWords;
begin
  level := 1;
  inputStr := '';

  while level <= 4 do
  begin
    counter := 0;
    while counter < 3 do
    begin
      stageArr := RandomArr(words, level + 4);

      writeln('���� 2. ������� ', level);
      write(stageArr[1]);
      for var i := 2 to level + 4 do
        write(' ', stageArr[i]);
      writeln;
      sleep(5000);
      ClearScreen();

      writeln('���� 2. ������� ', level, #13#10, '������� ����a � ����� �������:');

      repeat
        readln(inputStr);
        TrimString(inputStr);
        inputStr := AnsiUpperCase(inputStr);
        case IsValid(inputStr) of
          $01:
            writeln('������ ������. ��������� ����.');
          $10:
            writeln('������������ ����. ��������� ����.');
        end;
      until IsValid(inputStr) = $00;

      if IsValidS2(stageArr, level + 4, inputStr) = False then
      begin
        writeln('����� ��������! ���������� ��� ���.');
        counter := 0;
        writeln('��������: ', counter, ' �� 3.');
      end
      else
      begin
        writeln('����� ������!');
        inc(counter);
        writeln('��������: ', counter, ' �� 3.');
      end;

      writeln('������� Enter, ����� ����������.');
      readln;
      ClearScreen();
    end;

    Inc(level);
  end;
  writeln('�� ������ ���� 2! �����������!');
  writeln('������� Enter, ����� ������� � ���������� �����.');
  readln;
  ClearScreen;
end;

procedure Stage3(words: TDictionary);
var
  level, counter: integer;
  inputStr: string;
  stageArr: TSetOfWords;
begin
  level := 1;
  inputStr := '';

  while level <= 4 do
  begin
    counter := 0;
    while counter < 3 do
    begin
      stageArr := RandomArr(words, level + 4);

      writeln('���� 3. ������� ', level);
      write(stageArr[1]);
      for var i := 2 to level + 4 do
        write(' ', stageArr[i]);
      writeln;
      sleep(5000);
      ClearScreen();

      writeln('���� 3. ������� ', level, #13#10, '������� ����a � ������� �������:');

      repeat
        readln(inputStr);
        TrimString(inputStr);
        inputStr := AnsiUpperCase(inputStr);
        case IsValid(inputStr) of
          $01:
            writeln('������ ������. ��������� ����.');
          $10:
            writeln('������������ ����. ��������� ����.');
        end;
      until IsValid(inputStr) = $00;

      if IsValidS3(stageArr, level + 4, inputStr) = False then
      begin
        writeln('����� ��������! ���������� ��� ���.');
        counter := 0;
        writeln('��������: ', counter, ' �� 3.');
      end
      else
      begin
        writeln('����� ������!');
        inc(counter);
        writeln('��������: ', counter, ' �� 3.');
      end;

      writeln('������� Enter, ����� ����������.');
      readln;
      ClearScreen();
    end;

    Inc(level);
  end;
  writeln('�� ������ ���� 3! �����������!');
  writeln('������� Enter, ����� ������� � ���������� �����.');
  readln;
  ClearScreen;
end;

procedure Stage4(words: TDictionary);
var
  level, counter: integer;
  inputStr: string;
  stageArr: TSetOfWords;
begin
  level := 1;
  inputStr := '';

  while level <= 4 do
  begin
    counter := 0;
    while counter < 3 do
    begin
      stageArr := RandomArr(words, level + 4);

      writeln('���� 4. ������� ', level);
      write(stageArr[1]);
      for var i := 2 to level + 4 do
        write(' ', stageArr[i]);
      writeln;
      sleep(5000);
      ClearScreen();

      writeln('���� 4. ������� ', level, #13#10, '������� ����������� ����a � ����� �������:');

      repeat
        readln(inputStr);
        TrimString(inputStr);
        inputStr := AnsiUpperCase(inputStr);
        case IsValid(inputStr) of
          $01:
            writeln('������ ������. ��������� ����.');
          $10:
            writeln('������������ ����. ��������� ����.');
        end;
      until IsValid(inputStr) = $00;

      if IsValidS4(stageArr, level + 4, inputStr) = False then
      begin
        writeln('����� ��������! ���������� ��� ���.');
        counter := 0;
        writeln('��������: ', counter, ' �� 3.');
      end
      else
      begin
        writeln('����� ������!');
        inc(counter);
        writeln('��������: ', counter, ' �� 3.');
      end;

      writeln('������� Enter, ����� ����������.');
      readln;
      ClearScreen();
    end;

    Inc(level);
  end;
  writeln('�� ������ ���� 4! �����������!');
  writeln('������� Enter, ����� ������� � ���������� �����.');
  readln;
  ClearScreen;
end;

procedure Stage5(words: TDictionary);
var
  level, counter: integer;
  inputStr: string;
  stageArr: TSetOfWords;
begin
  level := 1;
  inputStr := '';

  while level <= 4 do
  begin
    counter := 0;
    while counter < 3 do
    begin
      stageArr := RandomArr(words, level + 4);

      writeln('���� 5. ������� ', level);
      write(stageArr[1]);
      for var i := 2 to level + 4 do
        write(' ', stageArr[i]);
      writeln;
      sleep(5000);
      ClearScreen();

      writeln('���� 5. ������� ', level, #13#10, '������� ����������� � �������� �������:');

      repeat
        readln(inputStr);
        TrimString(inputStr);
        inputStr := AnsiUpperCase(inputStr);
        case IsValid(inputStr) of
          $01:
            writeln('������ ������. ��������� ����.');
          $10:
            writeln('������������ ����. ��������� ����.');
        end;
      until IsValid(inputStr) = $00;

      if IsValidS5(stageArr, level + 4, inputStr) = False then
      begin
        writeln('����� ��������! ���������� ��� ���.');
        counter := 0;
        writeln('��������: ', counter, ' �� 3.');
      end
      else
      begin
        writeln('����� ������!');
        inc(counter);
        writeln('��������: ', counter, ' �� 3.');
      end;

      writeln('������� Enter, ����� ����������.');
      readln;
      ClearScreen();
    end;

    Inc(level);
  end;
  writeln('�� ������ ���� 5! �����������!');
  writeln('������� Enter, ����� ������� � ���������� �����.');
  readln;
  ClearScreen;
end;

procedure StartGame();
var
  words: TDictionary;
  testSet: TSetOfWords;
begin
  writeln('����� ���������� � ���������� Memory Trainer!');
  writeln('������� Enter, ����� ������.');
  readln;
  ClearScreen;
  LoadDictionary(words);
  Stage1(words);
  Stage2(words);
  Stage3(words);
  Stage4(words);
  Stage5(words);
  writeln('�������, ��� ��������������� ����� �����������!');
  writeln('������� Enter, ����� �����.');
  readln;
end;

begin
  StartGame;

end.