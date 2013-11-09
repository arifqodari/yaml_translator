## YAML-Translator

YAML-Translator is a simple Ruby application to translate YAML translation file
in Rails project.

## Release

The current release is 1.0.
The next release will be packaged as Ruby gem.

## How to use it?

This application uses Microsoft Translator API service. Before you can use it,
please place your API Credentials on the `api_credentials.yml` file.

Please see [Getting Started Microsoft
Translator](http://msdn.microsoft.com/en-us/library/hh454950.aspx) for detailed
information how to obtain the API Credentials.

Then, you can simply running the translator by:

	ruby yaml_translator.rb language_code_from language_code_to

[List of language code](http://msdn.microsoft.com/en-us/library/ff512385.aspx)
