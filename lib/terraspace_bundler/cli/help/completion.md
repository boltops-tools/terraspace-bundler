## Examples

    terraspace-bundler completion

Prints words for TAB auto-completion.

    terraspace-bundler completion
    terraspace-bundler completion hello
    terraspace-bundler completion hello name

To enable, TAB auto-completion add the following to your profile:

    eval $(terraspace-bundler completion_script)

Auto-completion example usage:

    terraspace-bundler [TAB]
    terraspace-bundler hello [TAB]
    terraspace-bundler hello name [TAB]
    terraspace-bundler hello name --[TAB]
