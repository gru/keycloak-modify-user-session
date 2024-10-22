# Параметры Keycloak
$keycloakUrl = "http://localhost:8080"
$adminUsername = "admin"
$adminPassword = "admin_password"
$realm = "test"
$newUsername = "test_user"
$newPassword = "test_password"

# Получение токена администратора
$tokenUrl = "$keycloakUrl/realms/master/protocol/openid-connect/token"
$tokenBody = @{
    grant_type = "password"
    client_id = "admin-cli"
    username = $adminUsername
    password = $adminPassword
}

try {
    $tokenResponse = Invoke-RestMethod -Uri $tokenUrl -Method Post -Body $tokenBody -ContentType "application/x-www-form-urlencoded"
    $accessToken = $tokenResponse.access_token

    # Создание пользователя
    $createUserUrl = "$keycloakUrl/admin/realms/$realm/users"
    $createUserBody = @{
        username = $newUsername
        enabled = $true
        credentials = @(
            @{
                type = "password"
                value = $newPassword
                temporary = $false
            }
        )
        attributes = @{
            "current-role-id" = @("1")
        }
    } | ConvertTo-Json

    $headers = @{
        Authorization = "Bearer $accessToken"
        "Content-Type" = "application/json"
    }

    $createUserResponse = Invoke-RestMethod -Uri $createUserUrl -Method Post -Headers $headers -Body $createUserBody

    Write-Host "Пользователь $newUsername успешно создан в realm $realm"
}
catch {
    Write-Host "Ошибка при создании пользователя: $_"
}