
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

#source /usr/share/git-core/contrib/completion/git-prompt.sh
alias awsid='aws sts get-caller-identity && aws iam list-account-aliases --query "AccountAliases[]" --output text'
alias ec2instances='aws ec2 describe-instances --query "Reservations[].Instances[?State.Name=='\''running'\''].{Internal:PrivateDnsName,External:PublicDnsName,Name:Tags[?Key=='\''Name'\''].Value,Id:InstanceId}|[].{Id:Id,Internal:Internal,External:External,Name:Name[0]}" --output table'
alias cfnexports='aws cloudformation list-exports --query "Exports[].[Name,Value]" --output table'
complete -C aws_completer aws

awsregion() {
  if [[ -z $1 ]]; then
    PS3="Please choose an option "
    select option in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text --region us-east-1)
    do
      export AWS_DEFAULT_REGION=$option
      export AWS_REGION=$option
      break;
    done
  else
    export AWS_DEFAULT_REGION=$1
    export AWS_REGION=$1
  fi
}

_awsregion() {
  if [ $COMP_CWORD -eq 1 ]; then
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W $(aws ec2 describe-regions --query "Regions[].RegionName" --output text --region us-east-1) -- $cur) )
  fi
}

complete -F _awsregion awsregion

#GIT aliases
alias gis='git status'
alias gic='git commit'
alias gia='git add'
alias gil="git log --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(red)%d%C(reset)'"
alias gid='git diff'
alias gpull='git pull'
alias gpush='git push'

__gia () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local cword=$COMP_CWORD
  __git_complete_command add
}
__gic () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local cword=$COMP_CWORD
  __git_complete_command commit
}
__gil () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local cword=$COMP_CWORD
  __git_complete_command log
}
__gid () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local cword=$COMP_CWORD
  __git_complete_command diff
}
__gis () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local cword=$COMP_CWORD
  __git_complete_command status
}
__gpull () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local cword=$COMP_CWORD
  __git_complete_command pull
}
__gpush () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local cword=$COMP_CWORD
  __git_complete_command push
}

complete -F __gic gic
complete -F __gia gia
complete -F __gil gil
complete -F __gis gis
complete -F __gid gid
complete -F __gpull gpull
complete -F __gpush gpush

# configure git bash extension
export GIT_PS1_SHOWDIRTYSTATE='true'
export GIT_PS1_SHOWSTASHSTATE='true'
export GIT_PS1_SHOWUNTRACKEDFILES='true'

alias tsnode='node -r ts-node/register'
alias pj='npx projen'
alias cdk='npx cdk'
alias cdka='npx cdk -a cdk.out'
alias cdkw='npx cdkw'
alias l='ls -lah'
alias ..='cd ..'
alias psa='ps axu'
alias rm='rm -i'
alias myip='curl http://icanhazip.com'
alias npmclean='rm -rf node_modules/ package-lock.json yarn.lock'

search () {
  if [[ -z $1 ]]; then
    echo "Usage: search <text>";
  else
    grep -Rn "$1" .
  fi
}

__mvn_version() {
  if [[ -f pom.xml ]]; then
    pomVersion=$(xpath pom.xml "/project/version/text()" 2>/dev/null)
    echo $" ($(printf '\xe2\x93\x82') ${pomVersion})"
  fi
}

__npm_version() {
  if [[ -f package.json ]]; then
    npmVersion=$(jp -f package.json -u "version" 2>/dev/null)
    echo $" ($(printf '\xe2\x93\x83') ${npmVersion})"
  fi
}

__aws_profile() {
  if [[ ! -z "${AWS_PROFILE}" ]]; then
    echo $" ($(printf '\xe2\x92\xb6') ${AWS_PROFILE})"
  elif [[ ! -z "${AWS_IDENTITY}" ]]; then
    echo $" ($(printf '\xe2\x92\xb6') ${AWS_IDENTITY})"
  elif [[ ! -z "${AWS_VAULT}" ]]; then
    echo $" ($(printf '\xe2\x92\xb6') ${AWS_VAULT})"
  fi
}

__aws_region() {
  if [[ ! -z "${AWS_REGION}" ]]; then
    echo $" ($(printf '\xf0\x9f\x8c\x90') ${AWS_REGION})"
  fi
}
export PS1='[\u \W$(__git_ps1 " (%s)")$(__mvn_version)$(__npm_version)$(__aws_profile)$(__aws_region)]\$ '
