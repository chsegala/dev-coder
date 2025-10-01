ARG VARIANT="noble"
FROM buildpack-deps:${VARIANT}-curl

LABEL dev.containers.features="common zsh-plugins git homebrew docker"

ARG VARIANT
RUN if [ "$VARIANT" = "noble" ]; then \
        if id "ubuntu" &>/dev/null; then \
            echo "Deleting user 'ubuntu'  for $VARIANT" && userdel -f -r ubuntu || echo "Failed to delete ubuntu user for $VARIANT"; \  
        else \
            echo "User 'ubuntu' does not exist for $VARIANT"; \ 
        fi; \
    fi

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends build-essential procps curl file git sudo unzip bat zoxide fzf direnv

# Install gum
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor --batch --yes -o /etc/apt/keyrings/charm.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | tee /etc/apt/sources.list.d/charm.list \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get -y install gum

# Copy init-scripts
COPY ./scripts/init-scripts /usr/local/init-scripts
RUN chmod +x /usr/local/init-scripts/*.sh

# Set up login banner
RUN echo '/usr/local/init-scripts/banner.sh' >> /etc/profile.d/init-banner.s

# Create a non-root user to use if not already present
RUN adduser --disabled-password --uid 1000 coder \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/coder \
    && chmod 0440 /etc/sudoers.d/coder

USER coder

# Install oh-my-posh
RUN curl -s https://ohmyposh.dev/install.sh | bash -s
# Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 
# Install chezmoi
RUN sudo sh -c "$(curl -fsLS get.chezmoi.io)"

