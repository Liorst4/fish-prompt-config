# Change fish's prompt using only the terminal.

set __fish_sample_prompt_directory $__fish_data_dir/tools/web_config/sample_prompts

function __fish_prompt_config_list --description 'list available sample prompts'
    # TODO: Use only built-ins
    ls $__fish_sample_prompt_directory | cut -d '.' -f 1
end

function __fish_prompt_config_preview --argument-names prompt_name --description 'print a given sample prompt'
    functions -c fish_prompt __fish_prompt_backup

    # Load prompt
    source $__fish_sample_prompt_directory/$prompt_name.fish

    # Display prompt
    fish_prompt
    echo

    # Restore state
    set_color normal
    functions -e fish_prompt
    functions -c __fish_prompt_backup fish_prompt
    functions -e __fish_prompt_backup
end

function __fish_prompt_config_set --argument-names prompt_name --description 'replace current prompt with a sample prompt'
    cp $__fish_sample_prompt_directory/$prompt_name.fish $__fish_config_dir/functions/fish_prompt.fish
    source $__fish_config_dir/functions/fish_prompt.fish
end

function prompt_config --description 'configure the fish prompt'
    switch $argv[1]
        case list
            __fish_prompt_config_list
        case preview
            __fish_prompt_config_preview $argv[2]
        case set
            __fish_prompt_config_set $argv[2]
        case '*'
            # TODO: Usage string
            echo error
    end
end

# Set completions
set -l all_subcommands list preview set
for i in $all_subcommands
    complete -f -c prompt_config -n "not __fish_seen_subcommand_from $all_subcommands" -a $i
end
for i in 'set' 'preview'
    complete -f -c prompt_config -n "__fish_seen_subcommand_from $i" -a "(__fish_prompt_config_list)"
end
