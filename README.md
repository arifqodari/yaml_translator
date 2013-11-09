## YAML-Translator

YAML-Translator is a simple Ruby Gem to translate YAML translation file in Rails project.

## Release

The current version is 0.1.0.

## How to use it?

This application uses Microsoft Translator API service. Before using it, please register to Microsoft Translator API to obtain your `client_id` and `client_secret` keys.

Please see [Microsoft Translator](http://msdn.microsoft.com/en-us/library/hh454950.aspx) for detailed information how to obtain the API Credentials.

Then, you can simply running the translator by:

	translator = YAMLTranslator::Translation.new('your_client_id', 'your_client_secret')
	translator.translate('en', 'ar')

[List of language code](http://msdn.microsoft.com/en-us/library/hh456380.aspx)
