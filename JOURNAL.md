# sat 14/11

Studiando riguardo a come installare Wordpress ho adocchiato la repo ufficiale di wordpress docker su github (link nel readme)

Ho scoperto che loro scaricano wp similmente a come faccio io, e la configurazione la copiano da [wp-config-docker.php](https://github.com/docker-library/wordpress/blob/master/latest/php8.4/fpm/wp-config-docker.php), che ha una funzione speciale per sostituire le variabili ambientali.

```php
// a helper function to lookup "env_FILE", "env", then fallback
if (!function_exists('getenv_docker')) {
	// https://github.com/docker-library/wordpress/issues/588 (WP-CLI will load this file 2x)
	function getenv_docker($env, $default) {
		if ($fileEnv = getenv($env . '_FILE')) {
			return rtrim(file_get_contents($fileEnv), "\r\n");
		}
		else if (($val = getenv($env)) !== false) {
			return $val;
		}
		else {
			return $default;
		}
	}
}
```

Infatti, ricordiamoci che per Wordpress la configurazione, essendo php, è scriptabile di natura, non serve fare templates e poi sostituire le variabili all'avvio.

Siccome usando wp-cli dovrei appesantire l'immagine, oppure scaricarlo due volte (una a build e poi elimino, una a run per config), immagino che manterrò il mio approccio per la Build dell'immagine e aggiungero `wp-config.php` come file per COPY nella cartella tools/ o config/ di wordpress. Ripeto: php è un linguaggio e quindi posso fare una config che legge le variabili d'ambiente in maniera naturale.
