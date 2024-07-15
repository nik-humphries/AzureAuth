test_that("Check workload identity token works", {
  
  oidc_token_path <- Sys.getenv("AZURE_FEDERATED_TOKEN_FILE", unset = "/run/secrets/azure/tokens/azure-identity-token")
  skip_if(!file.exists(oidc_token_path))
  
  oidc_token <- readLines(oidc_token_path, warn = FALSE)
  
  # Define your Azure AD tenant and app ID (these are from env vars hopefully, but should allow to set it)
  tenant <- Sys.getenv("AZURE_TENANT_ID")
  client_id <- Sys.getenv("AZURE_CLIENT_ID")
  resource <- "https://storage.azure.com/.default"
  
  skip_if(tenant == "" || client_id == "" || resource == "")
  
  tok <- get_workload_token(resource = resource, use_cache = FALSE)
  
  expect_identical(decode_jwt(tok)$payload$tid, tenant)

  })

test_that("Check workload identity token works (cache)", {
  
  oidc_token_path <- Sys.getenv("AZURE_FEDERATED_TOKEN_FILE", unset = "/run/secrets/azure/tokens/azure-identity-token")
  skip_if(!file.exists(oidc_token_path))
  
  oidc_token <- readLines(oidc_token_path, warn = FALSE)
  
  # Define your Azure AD tenant and app ID (these are from env vars hopefully, but should allow to set it)
  tenant <- Sys.getenv("AZURE_TENANT_ID")
  client_id <- Sys.getenv("AZURE_CLIENT_ID")
  resource <- "https://storage.azure.com/.default"
  
  skip_if(tenant == "" || client_id == "" || resource == "")
  
  clean_token_directory(confirm = FALSE)
  
  tok <- get_workload_token(resource = resource, use_cache = TRUE)
  pretok <- tok$credentials$access_token
  tok <- get_workload_token(resource = resource, use_cache = TRUE)
  posttok <- tok$credentials$access_token
  
  testthat::expect_identical(pretok, posttok)

  tok$refresh()
  
  testthat::expect_true(posttok != tok$credentials$access_token)
  
  expect_identical(decode_jwt(tok)$payload$tid, tenant)
  
})