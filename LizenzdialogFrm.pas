unit LizenzdialogFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Actions,
  Vcl.ActnList, Vcl.ExtCtrls;

type
  TfrmLizenzdialog = class(TForm)
    Memo1: TMemo;
    cbLizenzGelesenUndAkzeptiert: TCheckBox;
    btnBeenden: TButton;
    btnLizenzAkzeptieren: TButton;
    btnLIzenzSpeichern: TButton;
    btnLizenzDrucken: TButton;
    ActionList1: TActionList;
    actLizenzSpeichern: TAction;
    actLizenzDrucken: TAction;
    Panel1: TPanel;
    procedure cbLizenzGelesenUndAkzeptiertClick(Sender: TObject);
    procedure btnBeendenClick(Sender: TObject);
    procedure btnLizenzSpeichernClick(Sender: TObject);
    procedure btnLizenzDruckenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actLizenzSpeichernExecute(Sender: TObject);
    procedure actLizenzDruckenExecute(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure LizenzSpeichern();
    procedure LizenzDrucken();
    procedure FillListWithLicenseText(var AList: TStringList);
  public
    { Public-Deklarationen }
    class procedure LizenzAkzeptierenAllInclusive();
  end;

const
  cFilenameLizenzAkzeptiert = 'IcsAutoImporter.lizenzakzeptiert';

implementation

uses
  VCL.Printers, System.IOUtils;

{$R *.dfm}

procedure TfrmLizenzdialog.actLizenzDruckenExecute(Sender: TObject);
begin
  LizenzDrucken();
end;

procedure TfrmLizenzdialog.actLizenzSpeichernExecute(Sender: TObject);
begin
  LizenzSpeichern();
end;

procedure TfrmLizenzdialog.btnBeendenClick(Sender: TObject);
begin
  Halt;
end;

procedure TfrmLizenzdialog.btnLizenzDruckenClick(Sender: TObject);
begin
  LizenzDrucken();
end;

procedure TfrmLizenzdialog.btnLizenzSpeichernClick(Sender: TObject);
begin
  LizenzSpeichern();
end;

procedure TfrmLizenzdialog.cbLizenzGelesenUndAkzeptiertClick(Sender: TObject);
begin
  btnLizenzAkzeptieren.Enabled := cbLizenzGelesenUndAkzeptiert.Checked;
end;

procedure TfrmLizenzdialog.FillListWithLicenseText(var AList: TStringList);
begin
  AList.Add('Mit der Benutzung der Software werden die Folgenden Lizenzbedingungen akzeptiert:');
  AList.Add('1. Unter keinen Umständen und unter keiner Rechtstheorie, ob unerlaubte Handlung (einschließlich Fahrlässigkeit), Vertrag oder anderweitig, ' +
    'haften die ursprünglichen Entwickler*innen, ein anderer Mitwirkender oder ein Vertreiber des abgedeckten Codes oder ein Lieferant einer dieser Parteien ' +
    'gegenüber einer Person für indirekte, besondere, zufällige oder Folgeschäden jeglicher Art, einschließlich, aber nicht beschränkt auf Schäden durch Verlust ' +
    'von Firmenwert, Arbeitsunterbrechung, Computerausfall oder -fehlfunktion oder alle anderen kommerziellen Schäden oder Verluste, selbst wenn diese Partei über ' +
    'die Möglichkeit solcher Schäden informiert wurde. Diese Haftungsbeschränkung gilt nicht für die Haftung für Todesfälle oder Personenschäden, die auf Fahrlässigkeit ' +
    'der betreffenden Partei zurückzuführen sind, sofern das geltende Recht eine solche Beschränkung verbietet. In einigen Rechtsordnungen ist der Ausschluss oder die ' +
    'Beschränkung von Neben- oder Folgeschäden nicht zulässig, so dass dieser Ausschluss und diese Beschränkung möglicherweise nicht für Sie gelten.');
  AList.Add('2. Wir übernehmen keine Garantie jeglicher Art, weder ausdrücklich noch stillschweigend, einschließlich, ohne Einschränkung, dass das Programm bzw. ' +
    'der Code frei von Mängeln ist, handelsüblich, geeignet für einen bestimmten Zweck oder nicht das Urheberrecht verletzend. Das gesamte Risiko in Bezug auf die Qualität ' +
    'und Leistung liegt bei Ihnen. Sollte sich das Programm oder der Code in irgendeiner Hinsicht als fehlerhaft erweisen, übernehmen Sie (nicht der ursprüngliche Entwickler ' +
    'oder ein anderer Mitwirkender) die Kosten für die notwendige Wartung, Reparatur oder Korrektur.');
  AList.Add('3. Gerichtsstandort ist Deutschland und es gilt deutsches Recht. Sofern zulässig wird der Gerichtsstandort auf Ulm festgelegt.');
  AList.Add('4. Diese Software darf nur in Übereinstimmung mit der internationalen Erklärung der Menschenrechte verwendet werden, wie von der Generalversammlung der ' +
    'Vereinten Nationen am 10. Dezember 1948 beschlossen.');
  AList.Add('5. Die Nutzung der Software oder des Codes ist nur zulässig, wenn diese Lizenz vollumfänglich akzeptiert und eingehalten wird.');
  AList.Add('6. Sollten einzelne Teile dieser Lizenz ungültig sein, so bleiben die restlichen Bestandteile unverändert in Kraft.');
end;

procedure TfrmLizenzdialog.FormShow(Sender: TObject);
var
  TmpList: TstringList;
begin
  Memo1.Clear;
  TmpList := TStringList.Create;
  try
    FillListWithLicenseText(TmpList);
    Memo1.Lines.Assign(TmpList);
  finally
    TmpList.Free;
  end;
end;

class procedure TfrmLizenzdialog.LizenzAkzeptierenAllInclusive;
var
  frmLizenzdialog: TfrmLizenzdialog;
  LizenzAkzeptiert: TStringList;
begin
  if FileExists(TPath.GetHomePath + TPath.DirectorySeparatorChar + cFilenameLizenzAKzeptiert) or FileExists(cFilenameLizenzAKzeptiert) then
    Exit;
  frmLizenzdialog := TfrmLizenzdialog.Create(nil);
  try
    if not frmLizenzdialog.ShowModal = mrOk then
      Halt;
    LizenzAkzeptiert := TStringList.Create;
    try
      LizenzAkzeptiert.SaveToFile(TPath.GetHomePath + TPath.DirectorySeparatorChar + cFilenameLizenzAKzeptiert);
    finally
      LizenzAkzeptiert.Free;
    end;
  finally
    frmLizenzdialog.Free;
  end;
end;

procedure TfrmLizenzdialog.LizenzDrucken;
label
  ZeileFortsetzen;
var
  PrintDialogue: TPrintDialog;
  Breite, Hoehe, Links, Oben, X, Y: Integer;
  I, J, PosLetztLeerz: Integer;
  TmpList, MemoErsatzListe: TStringList;
  Tmp: string;
begin
  PrintDialogue := TPrintDialog.Create(nil);
  try
    if PrintDialogue.Execute() then
    begin
      TmpList := TStringList.Create;
      MemoErsatzListe := TStringList.Create;
      try
        FillListWithLicenseText(MemoErsatzListe);
        Printer.BeginDoc;
        SetMapMode(Printer.Canvas.Handle, MM_LOMETRIC); //Umstellen auf 1/10 mm

        Printer.Canvas.Font.Name := 'Calibri';
        Printer.Canvas.Brush.Color := clWhite;
        Printer.Canvas.Font.Height := 50;

        //Blattgröße in 1/10 mm ermitteln:
        Breite := GetDeviceCaps(Printer.Canvas.Handle, HORZSIZE) * 10;
        Hoehe := GetDeviceCaps(Printer.Canvas.Handle, VERTSIZE) * 10;

        Links := 250; //2,5 cm
        Oben := 250; //2,5 cm

        X := Links;
        Y := Oben * (- 1);

        for I := 0 to MemoErsatzListe.Count - 1 do
        begin
          if ((Printer.Canvas.TextWidth(MemoErsatzListe[I])) >= (breite - (2 * Links))) then
          begin
            J := 1;
            PosLetztLeerz := 0;
            ZeileFortsetzen:
            Tmp := '';
            while (Printer.Canvas.TextWidth(Tmp) < (breite - (2 * Links))) and (J <= Length(MemoErsatzListe[I])) do
            begin
              Tmp := Tmp + MemoErsatzListe[I][J];
              if MemoErsatzListe[I][J] = ' ' then
                PosLetztLeerz := J;
              Inc(J);
            end;
            if (J <= Length(MemoErsatzListe[I])) and (J <> PosLetztLeerz) then
            begin
              Tmp := Tmp.Substring(0, Length(Tmp) - (J - PosLetztLeerz) + 1); //+1: Leerzeichen auch drucken für die Lesbarkeit mit Assistenzsoftware.
              J := PosLetztLeerz + 1;
            end;
            TmpList.Add(Tmp);
            if J <= Length(MemoErsatzListe[I]) then
              goto ZeileFortsetzen;
          end
          else
          begin
            TmpList.Add(MemoErsatzListe[I]);
          end;
        end;

        for I := 0 to TmpList.Count - 1 do
        begin

          if ((- 1) * Y) > (Hoehe - (2 * Oben)) then
          begin
            Y := Oben * (- 1);
            Printer.NewPage;
          end;

          Printer.Canvas.TextOut(x, y, TmpList[I]);

          Y := Y - Printer.Canvas.TextHeight(TmpList[I]);

        end;
        Printer.EndDoc;
      finally
        MemoErsatzListe.Free;
        TmpList.Free;
      end;
    end;
  finally
    PrintDialogue.Free;
  end;
end;

procedure TfrmLizenzdialog.LizenzSpeichern;
var
  SaveDialogue: TSaveDialog;
begin
  SaveDialogue := TSaveDialog.Create(nil);
  try
    SaveDialogue.Filter := 'Textdateien|*.txt';
    SaveDialogue.DefaultExt := 'txt';
    SaveDialogue.Title := 'Lizenzdatei speichern';
    SaveDialogue.Options := [ofOverwritePrompt, ofOldStyleDialog, ofHideReadOnly, ofEnableSizing];

    if SaveDialogue.Execute() then
      Memo1.Lines.SaveToFile(SaveDialogue.FileName);
  finally
    SaveDialogue.Free;
  end;
end;

end.



