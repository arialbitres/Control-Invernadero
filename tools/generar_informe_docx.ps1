param(
    [string]$Source = (Join-Path $PSScriptRoot '..\docs\INFORME_CONTROL_INVERNADERO.md'),
    [string]$OutputDocx = (Join-Path $PSScriptRoot '..\docs\Informe-Control-Invernadero.docx'),
    [string]$OutputPdf = (Join-Path $PSScriptRoot '..\docs\Informe-Control-Invernadero.pdf')
)

$ErrorActionPreference = 'Stop'
$wdCollapseEnd = 0
$wdPageBreak = 7
$wdAlignLeft = 0
$wdAlignCenter = 1
$wdFormatDocumentDefault = 16
$wdExportFormatPDF = 17
$wdFieldEmpty = -1

function Clean-Markdown([string]$Text) {
    $clean = $Text -replace '\*\*', ''
    $clean = $clean -replace '`', ''
    $clean = $clean -replace '^>\s*', ''
    return $clean
}

function Set-SelectionFont($Selection, [string]$Name, [double]$Size, [bool]$Bold = $false, [bool]$Italic = $false) {
    $Selection.Font.Name = $Name
    $Selection.Font.Size = $Size
    $Selection.Font.Bold = [int]$Bold
    $Selection.Font.Italic = [int]$Italic
}

function Add-Paragraph($Selection, [string]$Text, [double]$Size = 11, [bool]$Bold = $false,
    [int]$Alignment = 0, [double]$SpaceAfter = 6, [bool]$Italic = $false) {
    Set-SelectionFont $Selection 'Arial' $Size $Bold $Italic
    $Selection.ParagraphFormat.Alignment = $Alignment
    $Selection.ParagraphFormat.SpaceAfter = $SpaceAfter
    $Selection.ParagraphFormat.LineSpacingRule = 0
    $Selection.TypeText((Clean-Markdown $Text))
    $Selection.TypeParagraph()
}

function Move-AfterTable($Selection, $Table) {
    $end = $Table.Range.End
    $Selection.SetRange($end, $end)
    $Selection.TypeParagraph()
}

function Add-CodeTable($Document, $Selection, [string]$Description, [string]$Code) {
    $range = $Selection.Range
    $table = $Document.Tables.Add($range, 2, 1)
    $table.Borders.Enable = 1
    $table.AllowAutoFit = $true
    $table.Cell(1, 1).Range.Text = $Description
    $table.Cell(1, 1).Range.Font.Name = 'Arial'
    $table.Cell(1, 1).Range.Font.Size = 9
    $table.Cell(1, 1).Range.Font.Bold = 1
    $table.Cell(1, 1).Shading.BackgroundPatternColor = 14277081
    $table.Cell(2, 1).Range.Text = $Code.TrimEnd()
    $table.Cell(2, 1).Range.Font.Name = 'Courier New'
    $table.Cell(2, 1).Range.Font.Size = 8
    $table.Cell(2, 1).Range.ParagraphFormat.SpaceAfter = 0
    Move-AfterTable $Selection $table
}

function Add-MarkdownTable($Document, $Selection, [System.Collections.Generic.List[string]]$Lines) {
    $rows = New-Object System.Collections.Generic.List[object]
    foreach ($line in $Lines) {
        if ($line -match '^\|?[\s|:\-]+\|?$') { continue }
        $trimmed = $line.Trim().Trim('|')
        $cells = @($trimmed.Split('|') | ForEach-Object { (Clean-Markdown $_.Trim()) })
        $rows.Add($cells)
    }
    if ($rows.Count -eq 0) { return }

    $columns = $rows[0].Count
    $table = $Document.Tables.Add($Selection.Range, $rows.Count, $columns)
    $table.Borders.Enable = 1
    $table.AllowAutoFit = $true
    for ($r = 0; $r -lt $rows.Count; $r++) {
        for ($c = 0; $c -lt $columns; $c++) {
            $value = if ($c -lt $rows[$r].Count) { $rows[$r][$c] } else { '' }
            $cell = $table.Cell($r + 1, $c + 1)
            $cell.Range.Text = $value
            $cell.Range.Font.Name = 'Arial'
            $cell.Range.Font.Size = 8.5
            if ($r -eq 0) {
                $cell.Range.Font.Bold = 1
                $cell.Shading.BackgroundPatternColor = 14277081
            }
        }
    }
    Move-AfterTable $Selection $table
}

function Add-FieldFooter($Section) {
    $footer = $Section.Footers.Item(1)
    $footer.Range.ParagraphFormat.Alignment = $wdAlignCenter
    $footer.Range.Font.Name = 'Arial'
    $footer.Range.Font.Size = 9
    $range = $footer.Range
    $range.Text = 'Página '
    $range.Collapse($wdCollapseEnd)
    $null = $footer.Range.Fields.Add($range, $wdFieldEmpty, 'PAGE', $true)
    $range = $footer.Range
    $range.Collapse($wdCollapseEnd)
    $range.InsertAfter(' de ')
    $range.Collapse($wdCollapseEnd)
    $null = $footer.Range.Fields.Add($range, $wdFieldEmpty, 'NUMPAGES', $true)
}

$word = $null
$document = $null
try {
    $sourcePath = (Resolve-Path $Source).Path
    $docxPath = [System.IO.Path]::GetFullPath($OutputDocx)
    $pdfPath = [System.IO.Path]::GetFullPath($OutputPdf)
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($docxPath)) | Out-Null
    # Evita que Word agregue revisiones incrementales sobre artefactos previos.
    if (Test-Path -LiteralPath $docxPath) { [System.IO.File]::Delete($docxPath) }
    if (Test-Path -LiteralPath $pdfPath) { [System.IO.File]::Delete($pdfPath) }

    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0
    $document = $word.Documents.Add()

    $section = $document.Sections.Item(1)
    $section.PageSetup.PageWidth = 595.3
    $section.PageSetup.PageHeight = 841.9
    $section.PageSetup.TopMargin = 65
    $section.PageSetup.BottomMargin = 65
    $section.PageSetup.LeftMargin = 65
    $section.PageSetup.RightMargin = 55

    $normal = $document.Styles.Item(-1)
    $normal.Font.Name = 'Arial'
    $normal.Font.Size = 11

    $header = $section.Headers.Item(1).Range
    $header.Text = "Control de Invernadero IoT`r[COMPLETAR NOMBRES DE LOS INTEGRANTES]"
    $header.Font.Name = 'Arial'
    $header.Font.Size = 8
    $header.ParagraphFormat.Alignment = $wdAlignCenter
    Add-FieldFooter $section

    $selection = $word.Selection
    $lines = @(Get-Content -LiteralPath $sourcePath -Encoding UTF8)
    $onCover = $true

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]

        if ($line -eq '<!-- PAGEBREAK -->') {
            $selection.InsertBreak($wdPageBreak)
            $onCover = $false
            continue
        }

        if ($line -match '^```(.*)$') {
            $label = $Matches[1].Trim()
            $codeLines = New-Object System.Collections.Generic.List[string]
            $i++
            while ($i -lt $lines.Count -and $lines[$i] -notmatch '^```\s*$') {
                $codeLines.Add($lines[$i])
                $i++
            }
            $description = if ($label) { $label -replace '\s*\|\s*', ' — ' } else { 'Código / diagrama' }
            Add-CodeTable $document $selection $description ($codeLines -join "`r")
            continue
        }

        if ($line -match '^\|') {
            $tableLines = New-Object System.Collections.Generic.List[string]
            while ($i -lt $lines.Count -and $lines[$i] -match '^\|') {
                $tableLines.Add($lines[$i])
                $i++
            }
            $i--
            Add-MarkdownTable $document $selection $tableLines
            continue
        }

        if ($line -match '^(#{1,4})\s+(.+)$') {
            $level = $Matches[1].Length
            $text = $Matches[2]
            if ($onCover -and $level -eq 1) {
                Add-Paragraph $selection $text 20 $true $wdAlignCenter 18
            } else {
                $sizes = @{ 1 = 16; 2 = 14; 3 = 12; 4 = 11 }
                Add-Paragraph $selection $text $sizes[$level] $true $wdAlignLeft 8
            }
            continue
        }

        if ([string]::IsNullOrWhiteSpace($line)) {
            if ($onCover) { Add-Paragraph $selection '' 8 $false $wdAlignCenter 2 }
            continue
        }

        if ($line -match '^>\s*(.+)$') {
            Add-Paragraph $selection $Matches[1] 9 $false $wdAlignLeft 8 $true
            continue
        }

        if ($line -match '^\-\s+(.+)$') {
            Add-Paragraph $selection ("• " + $Matches[1]) 10.5 $false $wdAlignLeft 3
            continue
        }

        $alignment = if ($onCover) { $wdAlignCenter } else { $wdAlignLeft }
        $bold = $onCover -and ($line -match 'Instituto|Tecnicatura|Asignatura|Comisión|Profesor|Integrantes|Fecha')
        Add-Paragraph $selection $line 11 $bold $alignment 5
    }

    $document.Fields.Update() | Out-Null
    $document.SaveAs([ref]$docxPath, [ref]$wdFormatDocumentDefault)
    $document.ExportAsFixedFormat($pdfPath, $wdExportFormatPDF)
    Write-Output "DOCX=$docxPath"
    Write-Output "PDF=$pdfPath"
}
finally {
    if ($document) { $document.Close($false) }
    if ($word) { $word.Quit() }
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($document) 2>$null | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) 2>$null | Out-Null
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
