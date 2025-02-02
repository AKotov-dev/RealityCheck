unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Types,
  process, LCLType, Buttons, ComCtrls, IniPropStorage, ExtCtrls, AsyncProcess;

type

  { TMainForm }

  TMainForm = class(TForm)
    KillOpenSSL: TAsyncProcess;
    MaskBox: TComboBox;
    ProxyEdit: TEdit;
    IniPropStorage1: TIniPropStorage;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    ProgressBar1: TProgressBar;
    StartBtn: TSpeedButton;
    StaticText1: TStaticText;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure StartBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private


  public
    timeout: integer;

  end;

var
  MainForm: TMainForm;


implementation

uses start_trd;

  {$R *.lfm}

  { TMainForm }

//https://petrochenko.ru/lazarus/listbox-colors-bold.html
procedure TMainForm.ListBox1DrawItem(Control: TWinControl; Index: integer;
  ARect: TRect; State: TOwnerDrawState);
var
  txt: string;
begin
  with ListBox1 do
  begin
    // "Забираем" текст текущего пункта в переменную
    // (это даёт возможность его изменения)
    txt := Items[Index];

  {  // Присваиваем нужный цвет фона чётным/нечётным строкам
    if (Index mod 2) = 0 then Canvas.Brush.Color := clWindow
    else
      Canvas.Brush.Color := clSilver;

    // Выделенная строка
    if (odSelected in State) then
    begin
      Canvas.Brush.Color := clGreen;
      Canvas.Font.Color := clWhite;
    end;  }

    // Выделение пунктов, начинающихся с заданного символа
    if (txt[1] = 's') or (txt[1] = 'i') or (txt[1] = 'C') or (txt[1] = 'T') then
    begin
      Canvas.Font.Style := Canvas.Font.Style + [fsBold];
      // "отрезаем" символ-флаг
      txt := Copy(txt, 1, Length(txt));
    end
    else
      Canvas.Font.Style := Canvas.Font.Style - [fsBold];

    // Готовим канву к отрисовке
    Canvas.FillRect(ARect);
    // Отрисовываем текст с заданными параметрами
    Canvas.TextOut(ARect.Left + 4, ARect.Top, txt);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  MainForm.Caption := Application.Title;

  if not DirectoryExists(GetUserDir + '.config') then MkDir(GetUserDir + '.config');
  IniPropStorage1.IniFileName := GetUserDir + '.config/RealityCheck.conf';
end;

//Запускать по Enter
procedure TMainForm.FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = VK_Return then StartBtn.Click;
end;

//For Plasma DPI
procedure TMainForm.FormShow(Sender: TObject);
begin
  IniPropStorage1.Restore;
end;

//Запуск проверки сертификата
procedure TMainForm.StartBtnClick(Sender: TObject);
var
  FStartCheck: TThread;
begin
  ProxyEdit.Text := Trim(ProxyEdit.Text);
  MaskBox.Text := Trim(MaskBox.Text);

  if (ProxyEdit.Text = '') or (MaskBox.Text = '') then Exit;

  //Start
  FStartCheck := StartCheck.Create(False);
  FStartCheck.Priority := tpHighest;
end;

//TimeOut OpenSSL при зависании (8 sec)
procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Inc(timeout);

  if timeout = 8 then
  begin
    Timer1.Enabled := False;
    timeout := 0;
    KillOpenSSL.Execute;
    ListBox1.Clear;
    ListBox1.Items.Add('Timeout! Operation aborted!');
  end;
end;

end.
