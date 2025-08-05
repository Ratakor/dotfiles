# TODO: see this for how to do it correctly
# https://github.com/maeve-oake/nixos-config/blob/main/secrets/secrets.nix
# https://github.com/ItsShamed/tsrk-nix-flex/blob/master/secrets.nix
# https://nixos.wiki/wiki/Agenix#Usage
let
  key1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGVp4eJS6jiGYQ7syyvfNtaDHQt/JEQJe6mTnQAT1vM6";
  key2 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCXzlMNUUbwMnAQopIdY6QbAmtF74NNrC1Q7zST5Kvv0iM0QBUHuUqLM7IrMP7ZKocoUA0IbUTRuvp/ehWfDTyZ5K66HAU2eGJt7gO1BbizcXoyycd2CKs3cwHfrmrnS0F35LgmIXdwN1zp4Vi/sLdhKGjF5QXikIPafIZFv557S/ckIXqpgaGTd9A65T/bORCzKdGZUYHZKCQ1yqh3Sb7eH3OT+701052NJwToW6uDZ11aPdTzTu85pxHYllexG4GGjcXEP1FdN69EtPY3QS4lpiG7ZYic4G540LJOG10AbKCvdH64ZV57/V25T87zDBlT2FWyyrnS9a8DSZoDo74hLqrrZvvcq84DToJZBCYkHshCBHl+Ae0vQ3WtKDrjQJxFdJdE6MVMBefk6nyMuArl1gZfdBFatZUBfX1bhw8ee0uSXP69lFXF1V2LHmsgSNWvuOdQ493eFDlFjPkLvwHfzKNBQpKfTAE5Lu9EIbtLpcjU7sJQzvf12tMU35pztqM=";
in {
  "secret1.age".publicKeys = [key1 key2];
}
