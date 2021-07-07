Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$RDP_Shadow                      = New-Object system.Windows.Forms.Form
$RDP_Shadow.ClientSize           = New-Object System.Drawing.Point(500,500)
$RDP_Shadow.text                 = "RDP Теневое Клонирование"
$RDP_Shadow.TopMost              = $false

$ListView1                       = New-Object system.Windows.Forms.ListView
$ListView1.text                  = "listView"
$ListView1.width                 = 475
$ListView1.height                = 263
$ListView1.location              = New-Object System.Drawing.Point(11,226)

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.text                   = "PC Name or IP"
$TextBox1.width                  = 100
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(12,10)
$TextBox1.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TextBox2                        = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline              = $false
$TextBox2.text                   = "User Name"
$TextBox2.width                  = 100
$TextBox2.height                 = 20
$TextBox2.location               = New-Object System.Drawing.Point(11,43)
$TextBox2.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Connect"
$Button1.width                   = 110
$Button1.height                  = 63
$Button1.location                = New-Object System.Drawing.Point(183,136)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',12)
$Button1.ForeColor               = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$Button1.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("#b8e986")

$CheckBox1                       = New-Object system.Windows.Forms.CheckBox
$CheckBox1.text                  = "Control"
$CheckBox1.AutoSize              = $false
$CheckBox1.width                 = 95
$CheckBox1.height                = 20
$CheckBox1.location              = New-Object System.Drawing.Point(17,76)
$CheckBox1.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$RDP_Shadow.controls.AddRange(@($ListView1,$TextBox1,$TextBox2,$Button1,$CheckBox1))

$Button1.Add_Click({ MyFunction $this $_ })

function MyFunction ($sender,$event) { }


#Write your logic code here

[void]$RDP_Shadow.ShowDialog()