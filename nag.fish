function nag
    switch $argv[1]

    case 'repl'
        command nix repl

    case 'shell'
        argparse --name=nag 'pure' 'run=' -- $argv || return 1
        if set -q _flag_pure; and set -q _flag_run
            command nix-shell --no-build-hook --pure --packages $argv[2..] --run="$_flag_run"
        else if set -q _flag_pure
            command nix-shell --no-build-hook --pure --packages $argv[2..]
        else if set -q _flag_run
            command nix-shell --no-build-hook --packages $argv[2..] --run="$_flag_run"
        else if set -q argv[2]
            command nix-shell --no-build-hook --packages $argv[2..]
        else
            command nix-shell --no-build-hook
        end

    case 'search'
        command nix search $argv[2..]


    # ====================
    # ENVIRONMENT COMMANDS
    # ====================

    case 'install'
        if not set -q argv[2]
            echo 'ERROR: No argument was given' >&2
            return 1
        end

        command nix-env --install $argv[2..]

    case 'uninstall'
        if not set -q argv[2]
            echo 'ERROR: No argument was given' >&2
            return 1
        end

        command nix-env --uninstall $argv[2..]

    case 'upgrade'
        if not set -q argv[2]
            echo 'ERROR: No argument was given' >&2
            return 1
        end

        command nix-env --upgrade $argv[2..]

    case 'generations'
        command nix-env --list-generations

    case 'rollback'
        if set -q argv[2]
            command nix-env --switch-generation $argv[2]
        else
            command nix-env --rollback
        end


    # ==============
    # STORE COMMANDS
    # ==============
    # NOTE these are useful when comboed with `which` as in `nag deps (which rg)`

    case 'deriver'
        if not set -q argv[2]
            echo 'ERROR: No argument was given' >&2
            return 1
        end

        command nix-store --query --deriver $argv[2..]

    case 'deps'
        argparse --name=nag 'rev' -- $argv || return 1
        if not set -q argv[2]
            echo 'ERROR: No argument was given' >&2
            return 1
        end

        if set -q _flag_rev
            command nix-store --query --referrers $argv[2..]
        else
            command nix-store --query --references $argv[2..]
        end

    case 'closure'
        argparse --name=nag 'rev' 'tree' 'graphviz' 'graphml' -- $argv || return 1
        if not set -q argv[2]
            echo 'ERROR: No argument was given' >&2
            return 1
        end

        if set -q _flag_rev; and set -q _flag_tree
            echo 'ERROR: --tree cannot be combined with --rev, try --graphviz instead'
            return 1
        else if set -q _flag_graphviz; and set -q _flag_graphml
            echo 'ERROR: --graphviz cannot be combined with --graphml, you must pick one'
            return 1
        else if set -q _flag_tree; and not set -q _flag_rev
            command nix-store --query --tree $argv[2..]
        else if set -q _flag_graphviz; and not set -q _flag_rev
            command nix-store --query --graph $argv[2..]
        else if set -q _flag_graphml; and not set -q _flag_rev
            command nix-store --query --graphml $argv[2..]
        else if set -q _flag_rev
            command nix-store --query --referrers-closure $argv[2..]
        else if not set -q _flag_rev
            command nix-store --query --requisites $argv[2..]
        else
            echo 'ERROR: you cant use graphs with --rev queries'
            return 1
        end


    # ================
    # CHANNEL COMMANDS
    # ================

    case 'channels'
        switch "$argv[2]"
        case ''
            command nix-channel --list
        case 'add'
            command nix-channel --add $argv[3..]
        case 'remove'
            command nix-channel --remove $argv[3..]
        case 'update'
            command nix-channel --update $argv[3..]
        case 'rollback'
            command nix-channel --rollback $argv[3..]
        case *
            echo 'ERROR: unknown channels subcommand' >&2
            return 1
        end


    # ===================
    # DERIVATION COMMANDS
    # ===================

    case 'drv'
        switch "$argv[2]"
        case 'show'
            command nix show-derivation $argv[3..]
        case 'realise'
            command nix-store --realise $argv[3..]
        case *
            echo 'ERROR: unknown drv subcommand' >&2
            return 1
        end


    case 'help'
        # TODO


    case *
        echo 'ERROR: unknown subcommand' >&2
        return 1
    end
end


set -gx nag nag

