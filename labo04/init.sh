
# Get Repository
git clone https://github.com/deuskane/asylum-soc-OB8_gpio.git

# Create directory if unexist
mkdir -p ~/.config/fusesoc/

# Remove previous clone repo
rm -fr /home/user/.local/share/fusesoc/asylum-cores

# Add global Library
fusesoc library add asylum-cores https://github.com/deuskane/asylum-cores.git --global
