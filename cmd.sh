# install the certs manually
install_certs_dir --config /myacme/issues --run-post-hook
#  or
docker compose exec -T acme install_certs_dir --config /myacme/issues --run-post-hook