# Параметры Keycloak
$keycloakUrl = "http://localhost:8080"
$adminUsername = "admin"
$adminPassword = "admin_password"
$realm = "test"
$username = "test_user"
$newRoleId = "3"  # Новое значение для атрибута current-role-id

# Получение токена администратора
$tokenUrl = "$keycloakUrl/realms/master/protocol/openid-connect/token"
$tokenBody = @{
    grant_type = "password"
    client_id = "admin-cli"
    username = $adminUsername
    password = $adminPassword
}

try {
    # Получение токена
    $tokenResponse = Invoke-RestMethod -Uri $tokenUrl -Method Post -Body $tokenBody -ContentType "application/x-www-form-urlencoded"
    $accessToken = $tokenResponse.access_token

    # Поиск пользователя
    $getUserUrl = "$keycloakUrl/admin/realms/$realm/users?username=$username"
    $headers = @{
        Authorization = "Bearer $accessToken"
    }
    $userResponse = Invoke-RestMethod -Uri $getUserUrl -Method Get -Headers $headers

    if ($userResponse.Count -eq 0) {
        Write-Host "Пользователь $username не найден"
        exit
    }

    $userId = $userResponse[0].id

    # Обновление атрибута пользователя
    $updateUserUrl = "$keycloakUrl/admin/realms/$realm/users/$userId"
    $updateUserBody = @{
        attributes = @{
            "current-role-id" = @($newRoleId)
        }
    } | ConvertTo-Json

    $updateHeaders = @{
        Authorization = "Bearer $accessToken"
        "Content-Type" = "application/json"
    }

    Invoke-RestMethod -Uri $updateUserUrl -Method Put -Headers $updateHeaders -Body $updateUserBody

    Write-Host "Атрибут current-role-id пользователя $username успешно обновлен на значение $newRoleId"
}
catch {
    Write-Host "Ошибка при обновлении атрибута пользователя: $_"
}