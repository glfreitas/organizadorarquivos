unit uPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellCtrls, StdCtrls, ImgList, ToolWin, ActnList;

type
  TFormPrincipal = class(TForm)
    ShellTreeView1: TShellTreeView;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    GroupBox2: TGroupBox;
    TreeView1: TTreeView;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ImageList1: TImageList;
    ToolBar2: TToolBar;
    ToolButton7: TToolButton;
    Memo2: TMemo;
    ActionList1: TActionList;
    ACT_NovaPasta: TAction;
    ACT_RemoverPasta: TAction;
    ACT_NovoArquivo: TAction;
    ACT_RemoverArquivo: TAction;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ImageList2: TImageList;
    ToolButton10: TToolButton;
    procedure PR_MontaEstrutura(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure ToolButton7Click(Sender: TObject);
    procedure ACT_NovaPastaExecute(Sender: TObject);
    procedure ACT_RemoverPastaExecute(Sender: TObject);
    procedure ACT_NovoArquivoExecute(Sender: TObject);
    procedure ACT_RemoverArquivoExecute(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.PR_MontaEstrutura(Sender: TObject);
var
  Pasta : TTreeNode;
  i, j : Integer;
begin
  Pasta := TreeView1.Items.Add(nil, 'Imagens');
  TreeView1.Items.AddChild(Pasta,'.bmp');
  TreeView1.Items.AddChild(Pasta,'.png');
  TreeView1.Items.AddChild(Pasta,'.gif');
  TreeView1.Items.AddChild(Pasta,'.jpg');
  TreeView1.Items.AddChild(Pasta,'.jpeg');

  Pasta := TreeView1.Items.Add(nil, 'Documentos Word');
  TreeView1.Items.AddChild(Pasta,'.doc');
  TreeView1.Items.AddChild(Pasta,'.docx');
  TreeView1.Items.AddChild(Pasta,'.rtf');

  Pasta := TreeView1.Items.Add(nil, 'Documentos Excel');
  TreeView1.Items.AddChild(Pasta,'.xls');
  TreeView1.Items.AddChild(Pasta,'.xlsx');
  TreeView1.Items.AddChild(Pasta,'.csv');

  Pasta := TreeView1.Items.Add(nil, 'Excutaveis');
  TreeView1.Items.AddChild(Pasta,'.exe');
  TreeView1.Items.AddChild(Pasta,'.msi');

  Pasta := TreeView1.Items.Add(nil, 'Compactados');
  TreeView1.Items.AddChild(Pasta,'.rar');
  TreeView1.Items.AddChild(Pasta,'.zip');

  for i := 0 to TreeView1.Items.Count - 1 do
  begin
    TreeView1.Items[i].ImageIndex := 0;

    for j := 0 to TreeView1.Items[i].Count - 1 do
    begin
      TreeView1.Items[i].Item[j].ImageIndex := 1;
    end
  end;

end;

procedure TFormPrincipal.FormShow(Sender: TObject);
var Pasta : TTreeNode;
begin
  ShellTreeView1.Path := ExtractFilePath(Application.ExeName);
  PR_MontaEstrutura(self);
end;

procedure TFormPrincipal.ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
var
  VAR_Extensao : String;
  F : TSearchRec;
  Ret : Integer;
begin

  Ret := FindFirst(ShellTreeView1.Path + '\*.*', faAnyFile, F);
  try
    Memo1.Clear;

    while Ret = 0 do
    begin
      VAR_Extensao := Copy(F.Name, length(F.Name) - 3, 4);

      if (VAR_Extensao <> '.') and (VAR_Extensao <> '..') then
      begin
        Memo1.Lines.Add('('+ExtractFileExt(F.Name)+') ' + F.Name);
      end;
      Ret := FindNext(F);
    end;

    finally
    begin
      FindClose(F);
    end;
  end;
end;

procedure TFormPrincipal.ToolButton7Click(Sender: TObject);
var
  F : TSearchRec;
  Ret, i, j : Integer;
  Pasta, VAR_Extensao : String;
  DOrigem, DDestino : String;
begin
  Ret := FindFirst(ShellTreeView1.Path + '\*.*', faAnyFile, F);

  while Ret = 0 do
  begin
    VAR_Extensao := ExtractFileExt(F.Name);

    if (VAR_Extensao <> '.') and (VAR_Extensao <> '..') then
    begin
      for i := 0 to TreeView1.Items.Count - 1 do
      begin
        for j := 0 to TreeView1.Items[i].Count - 1 do
        begin

          if (LowerCase(VAR_Extensao) = LowerCase(TreeView1.Items[i].Item[j].Text)) and (F.Name <> ExtractFileName(Application.ExeName) ) then
          begin
            Pasta := ShellTreeView1.Path + '\' + TreeView1.Items[i].Text;
            if not DirectoryExists(Pasta) then
              CreateDir(Pasta);

            DOrigem := ShellTreeView1.Path + '\' + F.Name;
            DDestino := Pasta + '\' + F.Name;

            //DOrigem := F.Name;
            //DDestino := Pasta + '\' + F.Name;
            
            if MoveFile(PChar(DOrigem), PChar(DDestino)) then
              Memo2.Lines.Add(DOrigem + ' - ' + DDestino)
            else
              Memo2.Lines.Add('Erro - ' + DOrigem);

          end
        end
      end;
    end;
    Ret := FindNext(F);
  end;

  MessageDlg('Arquivos organizados com sucesso.',mtInformation, [mbOK],1);

end;

procedure TFormPrincipal.ACT_NovaPastaExecute(Sender: TObject);
Var Item : String;
begin
  Item := InputBox('Nova Pasta','Informe o nome da pasta.','');
  if Item <> EmptyStr then
    TreeView1.Items.Add(nil,Item);
end;

procedure TFormPrincipal.ACT_RemoverPastaExecute(Sender: TObject);
begin
  if MessageDlg('Tem certeza que quer remover esta pasta?', mtConfirmation, [mbYes, mbNo],1) = 6 then
    TreeView1.Selected.Delete;
end;

procedure TFormPrincipal.ACT_NovoArquivoExecute(Sender: TObject);
Var Item : String;
begin

  Item := InputBox('Novo tipo de arquivo','Informe a extenção dos arquivos.','');
  if Item <> EmptyStr then
    TreeView1.Items.AddChild(TreeView1.Selected,Item);
end;

procedure TFormPrincipal.ACT_RemoverArquivoExecute(Sender: TObject);
begin
  if MessageDlg('Tem certeza que deseja remover este tipo de arquivo?', mtConfirmation, [mbYes, mbNo],1) = 6 then
      TreeView1.Selected.Delete;
end;

procedure TFormPrincipal.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if TreeView1.Selected.Level = 0 then
  begin
    ACT_RemoverPasta.Enabled := True;
    ACT_NovoArquivo.Enabled := True;
    ACT_RemoverArquivo.Enabled := False;
  end;

  if TreeView1.Selected.Level = 1 then
  begin
    ACT_RemoverPasta.Enabled := False;
    ACT_RemoverArquivo.Enabled := True;
  end;
end;

end.
