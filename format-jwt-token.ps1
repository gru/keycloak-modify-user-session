function Format-JwtToken {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Token
    )

    # Разделяем токен на части
    $tokenParts = $Token.Split('.')

    if ($tokenParts.Length -ne 3) {
        Write-Error "Неверный формат JWT токена"
        return
    }

    # Функция для декодирования Base64Url
    function ConvertFrom-Base64Url {
        param ([string]$base64Url)
        $base64 = $base64Url.Replace('-', '+').Replace('_', '/')
        switch ($base64.Length % 4) {
            0 { break }
            2 { $base64 += '==' }
            3 { $base64 += '=' }
        }
        return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64))
    }

    # Декодируем и форматируем каждую часть токена
    $header = ConvertFrom-Base64Url $tokenParts[0] | ConvertFrom-Json | ConvertTo-Json -Depth 100
    $payload = ConvertFrom-Base64Url $tokenParts[1] | ConvertFrom-Json | ConvertTo-Json -Depth 100

    # Выводим результат
    Write-Host "Заголовок JWT:"
    Write-Host $header -ForegroundColor Cyan
    Write-Host "`nПолезная нагрузка JWT:"
    Write-Host $payload -ForegroundColor Green
    Write-Host "`nПодпись JWT (закодирована):"
    Write-Host $tokenParts[2] -ForegroundColor Yellow
}