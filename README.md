#hubflow-extratools

Tools improving HubFlow

"git hf" is a Git extension to provide high-level repository operations 
for [DataSift's HubFlow branching model](http://datasift.github.com/gitflow/), which is based on [Vincent Driessen’s original blog post](http://nvie.com/posts/a-successful-git-branching-model/).

Fork of [DataSift's HubFlow branching model](http://datasift.github.com/gitflow/). Original is too unstable to me.

##Actions

1. Extend "git hf feature" with "git hf feature rstart".
  * "git hf feature rstart" find open issues in github repo and allows you to choose one of them before call "git hf feature start" &lt;issue_number&gt;-&lt;issue_title&gt;-&lt;user&gt;
  * "git hf feature rstart" also assigned this issue to user

2. Extend "git hf feature finish" to close related issue (ussing branch name **&lt;issue_number&gt;**-&lt;issue_title&gt;-&lt;user&gt;)

##Requires

Good config of user.name and user.email in .gitconfig

´´´
[user]
        name = Israel Calvete
        email = icalvete@gmail.com
[color]
        ui = true
[core]
        editor = vim
        excludesfile = ~/.gitignore
        [alias]
        co = checkout
        br = branch
        ci = commit
        st = status
        last = log -1 HEAD
        unstage = reset HEAD --
´´´

##Installation

1. git clone https://github.com/icalvete/gitflow-tools.git
2. cd gitflow-tools
3. cp -a git* hubflow* &lt;Some path in our $PATH&gt;
4. put your [github auth token](https://help.github.com/articles/creating-an-access-token-for-command-line-use) in git_flow_tools.conf file

##Getting Started with HubFlow

See our tutorial website to learn more about the [GitFlow](http://datasift.github.com/gitflow/IntroducingGitFlow.html) branching model and [how to use the HubFlow tools](http://datasift.github.com/gitflow/GitFlowForGitHub.html).

##Authors:

Israel Calvete Talavera <icalvete@gmail.com>
