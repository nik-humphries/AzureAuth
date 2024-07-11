#' @param oidc_token_path Path to the workload identity injected OIDC token, defaults to "/run/secrets/azure/tokens/azure-identity-token" for aks
#' @rdname get_azure_token
#' @export
get_workload_token <- function(resource, tenant = Sys.getenv("AZURE_TENANT_ID"), app = Sys.getenv("AZURE_CLIENT_ID"), oidc_token_path = "/run/secrets/azure/tokens/azure-identity-token", password=NULL, username=NULL, certificate=NULL, auth_type=NULL,
                               aad_host="https://login.microsoftonline.com/", version=2,
                               authorize_args=list(), token_args=list(),
                               use_cache=NULL, on_behalf_of=NULL, auth_code=NULL, device_creds=NULL)
{
  
  # Stop if oidc_token_path doesn't exist
  stopifnot(file.exists(oidc_token_path))
  
  token_args <- modifyList(token_args, list(oidc_token_path=oidc_token_path))
  
  common_args <- list(
    resource=resource,
    tenant=tenant,
    app=app,
    password=password,
    username=username,
    certificate=certificate,
    aad_host=aad_host,
    version=version,
    token_args=token_args,
    use_cache=use_cache
  )
  
  AzureTokenWorkload$new(common_args)
  
}