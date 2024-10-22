# Параметры Keycloak
$keycloakUrl = "http://localhost:8080"
$realm = "test"
$clientId = "public-client"
$username = "test_user"
$password = "test_password"

# Формирование URL для запроса токена
$tokenUrl = "$keycloakUrl/realms/$realm/protocol/openid-connect/token"

# Подготовка тела запроса
$body = @{
    grant_type = "password"
    client_id = $clientId
    username = $username
    password = $password
}

# Отправка запроса и получение ответа
try {
    $response = Invoke-RestMethod -Uri $tokenUrl -Method Post -Body $body -ContentType "application/x-www-form-urlencoded"

    # Вывод токена доступа
    Write-Host "Access Token:"
    Write-Host $response.access_token

    # Вывод токена обновления (если есть)
    if ($response.refresh_token) {
        Write-Host "`nRefresh Token:"
        Write-Host $response.refresh_token
    }
}
catch {
    Write-Host "Ошибка при получении токена: $_"
}