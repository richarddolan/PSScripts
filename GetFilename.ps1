Function Get-FileName($initialDirectory)
{
	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null
	
	$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	$OpenFileDialog.initialDirectory = "C:\Users\rdolan\OneDrive - Jackson Healthcare\WindowsPowerShell"
	$OpenFileDialog.filter = "CSV (*.csv)|*.csv"
	$OpenFileDialog.ShowDialog()|Out-Null
	$OpenFileDialog.filename
}