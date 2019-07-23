program OrganizadorArquivos;

uses
  Forms,
  uPrincipal in 'uPrincipal.pas' {FormPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Organizador de Arquivos';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
