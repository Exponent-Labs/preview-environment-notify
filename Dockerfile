FROM ruby:2.6.0

LABEL "com.github.actions.name"="Preview Environment notify"
LABEL "com.github.actions.description"="Leaves a comment on an open PR matching a push event."
LABEL "com.github.actions.repository"="https://github.com/Exponent-Labs/preview-environment-notify"
LABEL "com.github.actions.maintainer"="Chris Norman <chris@exponentlabs.io>"
LABEL "com.github.actions.icon"="message-square"
LABEL "com.github.actions.color"="blue"

RUN gem install octokit

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]