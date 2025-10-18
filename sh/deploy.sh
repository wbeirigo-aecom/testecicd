#!/bin/bash

# Criar o usuário 'deploy' sem senha
sudo useradd -m -s /bin/bash deploy
sudo passwd -l deploy  # bloqueia o uso de senha


# Criar diretório .ssh e definir permissões
sudo mkdir -p /home/deploy/.ssh
sudo chmod 700 /home/deploy/.ssh
sudo chown deploy:deploy /home/deploy/.ssh


# Gerar chave SSH (sem senha)
sudo -u deploy ssh-keygen -t rsa -b 4096 -f /home/deploy/.ssh/id_rsa -N ""

# Adicionar chave pública ao authorized_keys
sudo cp /home/deploy/.ssh/id_rsa.pub /home/deploy/.ssh/authorized_keys
sudo chmod 600 /home/deploy/.ssh/authorized_keys
sudo chown deploy:deploy /home/deploy/.ssh/authorized_keys

echo "Usuário 'deploy' criado com acesso apenas por chave SSH."
echo "Chave privada está em /home/deploy/.ssh/id_rsa"

