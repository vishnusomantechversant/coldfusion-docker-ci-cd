# Staging Deployment Script
param(
    [string]$ImageTag = "develop",
    [string]$ServerUrl = "staging-server.company.com"
)

Write-Host "Starting staging deployment..." -ForegroundColor Green
Write-Host "Image Tag: $ImageTag" -ForegroundColor Yellow
Write-Host "Server URL: $ServerUrl" -ForegroundColor Yellow

# Load environment variables
if (Test-Path "env.staging") {
    Get-Content "env.staging" | ForEach-Object {
        if ($_ -match '^([^#][^=]+)=(.*)$') {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], 'Process')
        }
    }
    Write-Host "Environment variables loaded from env.staging" -ForegroundColor Green
} else {
    Write-Error "env.staging file not found!"
    exit 1
}

# Set GitHub repository
$env:GITHUB_REPOSITORY = $env:GITHUB_REPOSITORY

# Stop existing containers
Write-Host "Stopping existing staging containers..." -ForegroundColor Yellow
docker-compose -f docker-compose.staging.yml --env-file env.staging down

# Pull latest images
Write-Host "Pulling latest staging images..." -ForegroundColor Yellow
docker-compose -f docker-compose.staging.yml --env-file env.staging pull

# Start containers
Write-Host "Starting staging containers..." -ForegroundColor Yellow
docker-compose -f docker-compose.staging.yml --env-file env.staging up -d

# Wait for services to be ready
Write-Host "Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Health check
Write-Host "Performing health check..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://$ServerUrl:8555/test.cfm" -TimeoutSec 30
    if ($response.StatusCode -eq 200) {
        Write-Host "Staging deployment successful!" -ForegroundColor Green
        Write-Host "Application is accessible at: http://$ServerUrl:8555" -ForegroundColor Green
    } else {
        Write-Error "Health check failed with status code: $($response.StatusCode)"
        exit 1
    }
} catch {
    Write-Error "Health check failed: $($_.Exception.Message)"
    exit 1
}

Write-Host "Staging deployment completed successfully!" -ForegroundColor Green
