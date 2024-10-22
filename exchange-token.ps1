# Импорт функции Format-JwtToken из файла format-jwt-token.ps1
. "$PSScriptRoot\format-jwt-token.ps1"

# Параметры Keycloak
$keycloakUrl = "http://localhost:8080"
$realm = "test"
$publicClientId = "public-client"
$internalClientId = "internal-client"
$username = "test_user"
$password = "test_password"
$internalClientSecret = "1ZM3BuahKxnkmTjGgq3tmCjHqy1vSE5m"

# Функция для получения токена
function Get-KeycloakToken {
    param (
        [string]$TokenUrl,
        [hashtable]$Body
    )
    
    $response = Invoke-RestMethod -Uri $TokenUrl -Method Post -Body $Body -ContentType "application/x-www-form-urlencoded"
    return $response.access_token
}

# URL для запроса токена
$tokenUrl = "$keycloakUrl/realms/$realm/protocol/openid-connect/token"

# Получение токена для public-client
$publicClientBody = @{
    grant_type = "password"
    client_id = $publicClientId
    username = $username
    password = $password
}

$publicClientToken = Get-KeycloakToken -TokenUrl $tokenUrl -Body $publicClientBody

Write-Host "Токен для public-client получен:"
Write-Host $publicClientToken

# Выполнение token exchange
$exchangeBody = @{
    grant_type = "urn:ietf:params:oauth:grant-type:token-exchange"
    client_id = $internalClientId
    client_secret = $internalClientSecret
    subject_token = $publicClientToken
    requested_token_type = "urn:ietf:params:oauth:token-type:access_token"
    audience = $internalClientId
}

try {
    $exchangeResponse = Invoke-RestMethod -Uri $tokenUrl -Method Post -Body $exchangeBody -ContentType "application/x-www-form-urlencoded"
    
    Write-Host "Token Exchange выполнен успешно."
    Write-Host "Новый токен для internal-client:"
    Write-Host $exchangeResponse.access_token

    Write-Host "Расшифрованный токен:"
    Format-JwtToken -Token $exchangeResponse.access_token
}
catch {
    Write-Host "Ошибка при выполнении Token Exchange: $_"
}