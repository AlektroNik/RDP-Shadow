<# Требования:
1. На клиенте (тот компьютер, С которого подключаемся) должен стоять компонент - "Возможности рабочего стола" или "Media Foundation" (для Windows Server 2019)
Install-WindowsFeature Server-Media-Foundation

2. На сервере (тот компьютер, НА который подключаемся) должен быть включен RemoteRPC
https://winitpro.ru/index.php/2018/07/11/rdp-shadow-k-rabochemu-stolu-polzovatelya-windows-10/

HKLM\SYSTЕM\CurrеntCоntrоlSеt\Cоntrol\Tеrminal Sеrvеr
"AllоwRemotеRPС"=dwоrd:00000001

Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "AllowRemoteRPC"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "AllowRemoteRPC" -Value 1


Комбинации клавиш можно использовать
Ctrl + Alt + Break — переключения удаленного рабочего стола между режимами «во весь экран» и «в окне»

#>

# Конвертер кодировки при выводе, иначе поиск не работает по выводу
function ConvertTo-Encoding ([string]$From, [string]$To) {
	Begin {
		$encFrom = [System.Text.Encoding]::GetEncoding($from)
		$encTo = [System.Text.Encoding]::GetEncoding($to)
	}
	Process {
		$bytes = $encTo.GetBytes($_)
		$bytes = [System.Text.Encoding]::Convert($encFrom, $encTo, $bytes)
		$encTo.GetString($bytes)
	}
}

$PC = (Read-Host -Prompt "PC Name")
# $cred = Get-Credential

# Проверяем компьютер в домене или нет. Запрашивать Учетные данные или нет
if ((gwmi win32_computersystem).partofdomain -eq $true) {
	write-host -fore green "Мой комп в домене"
	$ss = Invoke-Command -ComputerName $PC `
		-ScriptBlock { qwinsta.exe } | ConvertTo-Encoding -From cp866 -To windows-1251
}
else {
	write-host -fore red "Мой комп НЕ в домене"
	$ss = Invoke-Command -ComputerName $PC `
		-ScriptBlock { qwinsta.exe } `
		-Credential $(Get-Credential) | ConvertTo-Encoding -From cp866 -To windows-1251
}

$Header = "SESSIONNAME", "USERNAME", "ID", "STATUS"
$sessions = (($ss) -replace "^[\s>]" , "" -replace "\s+" , "," | ConvertFrom-Csv -Header $Header)
$sessions
$SessionActiveID = ($sessions | Where-Object { $_.STATUS -eq 'Активно' -or $_.STATUS -eq 'Active' }).ID

# mstsc /shadow:($SessionActive.ID) /v:$PC /control /noConsentPrompt /prompt

# Проверяем компьютер в домене или нет. Запрашивать Учетные данные или нет
if ((gwmi win32_computersystem).partofdomain -eq $true) {
	write-host -fore green "Мой комп в домене"
	Start-Process -FilePath mstsc -ArgumentList "/shadow:$SessionActiveID /v:$PC /control /noConsentPrompt"
}
else {
	write-host -fore red "Мой комп НЕ в домене"
	Start-Process -FilePath mstsc -ArgumentList "/shadow:$SessionActiveID /v:$PC /control /noConsentPrompt /prompt"
}

