# Locale manager

This is a lightweight tool for managing big and articulated I18n localisation files, simply over the command line.

It is basically a Ruby wrapper around the `yq` library, for sorting, adding, and modifying I18n YAML keys, launching its
commands via `rake`.

## Sort alphabetically

By calling `rake lm:sort filename.yml`, YAML files can be sorted alphabetically. This works also if multiple files are specified.


## Add or update a key and its value

A key/value pair can be added by running `rake lm:add newkey newvalue pathtofile`.
Values that use whitespaces need to be wrapped in quotes, as in the example below:

```
  rake lm:add en.flash.error.wrong_password 'Wrong password - try again' en.yml
```

This command can also be used to update the value of an existing key.


## Remove a key and its value

For removing a key, run `rake lm:del key_to_be_removed path_to_file`, as in the example below.

```
  rake lm:del en.errors en.yml
```

## Add all translations in one go

Notes for us:

YAML can successfully parse these yml files with merge keys only using an `unsafe_load` .
The folded block scalar operator `>` seems to apply a lot of unnecessary whitespaces when the value spans over multiple lines in the new sorted file.
The literal block scalar `|` seems to be a good alternative for multiline values, in case.