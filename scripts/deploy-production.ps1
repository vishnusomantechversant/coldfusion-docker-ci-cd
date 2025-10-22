# Production Deployment Script
param(
    [string]$ImageTag = "latest",
    [string]$ServerUrl = "production-server.company.com"
)

Write-Host "Starting production deployment..." -ForegroundColor Green
Write-Host "Image Tag: $ImageTag" -ForegroundColor Yellow
Write-Host "Server URL: $ServerUrl" -ForegroundColor Yellow

# Load environment variables
if (Test-Path "env.production") {
    Get-Content "env.production" | ForEach-Object {
        if ($_ -match '^([^#][^=]+)=(.*)$') {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], 'Process')
        }
    }
    Write-Host "Environment variables loaded from env.production" -ForegroundColor Green
} else {
    Write-Error "env.production file not found!"
    exit 1
}

# Set GitHub repository
$env:GITHUB_REPOSITORY = $env:GITHUB_REPOSITORY

# Create backup before deployment
Write-Host "Creating backup before deployment..." -ForegroundColor Yellow
$backupDir = "backups/$(Get-Date -Format 'yyyyMMdd-HHmmss')"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

# Stop existing containers
Write-Host "Stopping existing production containers..." -ForegroundColor Yellow
docker-compose -f docker-compose.production.yml --env-file env.production down

# Pull latest images
Write-Host "Pulling latest production images..." -ForegroundColor Yellow
docker-compose -f docker-compose.production.yml --env-file env.production pull

# Start containers
Write-Host "Starting production containers..." -ForegroundColor Yellow
docker-compose -f docker-compose.production.yml --env-file env.production up -d

# Wait for services to be ready
Write-Host "Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

# Health check
Write-Host "Performing health check..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://$ServerUrl/test.cfm" -TimeoutSec 30
    if ($response.StatusCode -eq 200) {
        Write-Host "Production deployment successful!" -ForegroundColor Green
        Write-Host "Application is accessible at: https://$ServerUrl" -ForegroundColor Green
    } else {
        Write-Error "Health check failed with status code: $($response.StatusCode)"
        exit 1
    }
} catch {
    Write-Error "Health check failed: $($_.Exception.Message)"
    exit 1
}

# Cleanup old backups (keep last 5)
Write-Host "Cleaning up old backups..." -ForegroundColor Yellow
Get-ChildItem -Path "backups" -Directory | Sort-Object CreationTime -Descending | Select-Object -Skip 5 | Remove-Item -Recurse -Force

Write-Host "Production deployment completed successfully!" -ForegroundColor Green
