unit start_trd;

{$mode objfpc}{$H+}

interface

uses
  Classes, Process, SysUtils, ComCtrls, Forms;

type
  StartCheck = class(TThread)
  private

    { Private declarations }
  protected
  var
    Result: TStringList;

    procedure Execute; override;

    procedure ShowLog;
    procedure StartProgress;
    procedure StopProgress;

  end;

implementation

uses Unit1;

  { TRD }

procedure StartCheck.Execute;
var
  ExProcess: TProcess;
begin
  try //Вывод лога и прогресса
    Synchronize(@StartProgress);

    FreeOnTerminate := True; //Уничтожить по завершении
    Result := TStringList.Create;

    ExProcess := TProcess.Create(nil);

    ExProcess.Executable := 'bash';
    ExProcess.Options := [poUsePipes, poStderrToOutPut, poWaitOnExit];
    ExProcess.Parameters.Add('-c');

    ExProcess.Parameters.Add(
      'echo "" | openssl s_client -showcerts -connect ' + MainForm.ProxyEdit.Text +
      ' -servername ' + MainForm.MaskBox.Text + ' | grep -E ' +
      '''' + '(subject|issuer)' + '''' + '; if [ $? -ne 0 ]; then exit 1; fi');


 {  ExProcess.Parameters.Add(
  'timeout 10 bash -c "openssl s_client -showcerts -connect ' + MainForm.Edit1.Text +
  ' -servername ' + MainForm.ComboBox1.Text +
  ' | grep -E ''(subject|issuer)''; if [ $? -ne 0 ]; then exit 1; fi"');}

 { ExProcess.Parameters.Add(
  'timeout 5 bash -c "openssl s_client -showcerts -connect ' + MainForm.Edit1.Text +
  ' -servername ' + MainForm.ComboBox1.Text +
  '" | grep -E ''(subject|issuer)''');}

    ExProcess.Execute;

    //Выводим лог динамически
    //    while ExProcess.Running do
    //    begin
    Result.LoadFromStream(ExProcess.Output);

    if Result.Count <> 0 then
      Synchronize(@ShowLog);
    //    end;

  finally
    Synchronize(@StopProgress);
    Result.Free;
    ExProcess.Free;
    Terminate;
  end;
end;

{ БЛОК ОТОБРАЖЕНИЯ ЛОГА }

//Старт
procedure StartCheck.StartProgress;
begin
  with MainForm do
  begin
    timeout := 0;
    MainForm.Timer1.Enabled := True;

    ListBox1.Clear;

    ListBox1.Items.Add('Certificate check: connecting via proxy ' +
      MainForm.ProxyEdit.Text + ' to ' + MainForm.MaskBox.Text);

    ListBox1.Items.Add('---');

    Application.ProcessMessages;
    ProgressBar1.Style := pbstMarquee;
    ProgressBar1.Refresh;
    StartBtn.Enabled := False;
  end;
end;

//Стоп
procedure StartCheck.StopProgress;
begin
  with MainForm do
  begin
    MainForm.Timer1.Enabled := False;
    timeout := 0;
    Application.ProcessMessages;
    ProgressBar1.Style := pbstNormal;
    ProgressBar1.Refresh;
    StartBtn.Enabled := True;
  end;
end;

//Вывод лога
procedure StartCheck.ShowLog;
var
  i: integer;
begin
  //Вывод построчно
  Result.Text := Trim(Result.Text);

  for i := 0 to Result.Count - 1 do
    MainForm.ListBox1.Items.Append(Result[i]);


  //Если список не пуст - курсор в "0"
  if MainForm.ListBox1.Count <> 0 then
    MainForm.ListBox1.ItemIndex := 0;

  //Промотать список вниз
  // MainForm.LogMemo.SelStart := Length(MainForm.LogMemo.Text);
  // MainForm.LogMemo.SelLength := 0;

  //Вывод пачками
  // MainForm.ListBox1.Items.Assign(Result);
end;

end.
