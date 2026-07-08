# Open Discord RPC server for atypical setups
# Require additional setup like vencord (see arrpc README)
{ config, ... }:
let
  cfg = config.self.services.arrpc;
in
{
  hm.services.arrpc.enable = cfg.enable;
}
