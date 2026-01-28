# PowerShell script to create a simple QR icon
Add-Type -AssemblyName System.Drawing

# Create new bitmap
$width = 1024
$height = 1024
$bitmap = New-Object System.Drawing.Bitmap($width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

try {
    # Set background to white
    $graphics.Clear([System.Drawing.Color]::White)

    # Dark blue circle (background)
    $darkBlueBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 64, 175))
    $graphics.FillEllipse($darkBlueBrush, 100, 100, 824, 824)

    # Lighter blue circle (inner)
    $lightBlueBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(59, 130, 246))
    $graphics.FillEllipse($lightBlueBrush, 200, 200, 624, 624)

    # White circle (inner)
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $graphics.FillEllipse($whiteBrush, 300, 300, 424, 424)

    # Draw QR symbol
    $qrBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 64, 175))

    # QR corners
    $graphics.FillRectangle($qrBrush, 350, 350, 120, 120)
    $graphics.FillRectangle($whiteBrush, 370, 370, 80, 80)
    $graphics.FillRectangle($qrBrush, 385, 385, 50, 50)

    $graphics.FillRectangle($qrBrush, 674, 350, 120, 120)
    $graphics.FillRectangle($whiteBrush, 694, 370, 80, 80)
    $graphics.FillRectangle($qrBrush, 709, 385, 50, 50)

    $graphics.FillRectangle($qrBrush, 350, 674, 120, 120)
    $graphics.FillRectangle($whiteBrush, 370, 694, 80, 80)
    $graphics.FillRectangle($qrBrush, 385, 709, 50, 50)

    # QR body
    for ($i = 0; $i -lt 12; $i++) {
        for ($j = 0; $j -lt 12; $j++) {
            if (($i + $j) % 2 -eq 0 -and $i -notin (0, 1, 2, 3, 11, 10, 9, 8) -and $j -notin (0, 1, 2, 3, 11, 10, 9, 8)) {
                $x = 420 + $i * 25
                $y = 420 + $j * 25
                $graphics.FillRectangle($qrBrush, $x, $y, 20, 20)
            }
        }
    }

    # Draw QR text
    $font = New-Object System.Drawing.Font("Arial", 180, [System.Drawing.FontStyle]::Bold)
    $stringFormat = New-Object System.Drawing.StringFormat
    $stringFormat.Alignment = [System.Drawing.StringAlignment]::Center
    $stringFormat.LineAlignment = [System.Drawing.StringAlignment]::Center

    $graphics.DrawString("QR", $font, $qrBrush, $width / 2, $height / 2 - 100, $stringFormat)

    # Draw O5DE text
    $font = New-Object System.Drawing.Font("Arial", 120, [System.Drawing.FontStyle]::Bold)
    $lightBlueBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(59, 130, 246))
    $graphics.DrawString("O5DE", $font, $lightBlueBrush, $width / 2, $height / 2 + 200, $stringFormat)

    # Create assets directory if doesn't exist
    $assetsDir = Join-Path $PWD.Path "assets" "images"
    if (-not (Test-Path $assetsDir -PathType Container)) {
        New-Item -Path $assetsDir -ItemType Directory -Force | Out-Null
    }

    # Save the icon
    $iconPath = Join-Path $assetsDir "app_icon.png"
    $bitmap.Save($iconPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "✅ App icon generated successfully: $iconPath"
}
catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}
finally {
    # Cleanup
    $graphics.Dispose()
    $bitmap.Dispose()
}
