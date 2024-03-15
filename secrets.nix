let
  laptop = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILA3Z+xq/ihH8ccZW8L4d0W4wRcqeCZyt38B0Pr4zAT3"
  ];
  castersj = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOseoqE3WwvWDdrtxXAiQuU9wxW9XtINk95XA/9y9luP"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKE+mQCTmudU6VSoxZ502MUJR7mgHwP4cUzT97r+khCY"
  ];

  hosts = laptop;
  users = castersj;
in {
  "secrets/passwords/networks.age".publicKeys = hosts ++ users;
}
