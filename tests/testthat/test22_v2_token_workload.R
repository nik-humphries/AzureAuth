test_that("Check workload identity token works", {
  
  oidc_token_path <- "/run/secrets/azure/tokens/azure-identity-token"
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