<?php
/**
 * @file yoursite.aliases.drushrc.php
 * Site aliases for [your site domain]
 * Place this file at ~/.drush/  (~/ means your home path)
 *
 * Usage:
 *   To copy the development database to your local site:
 *   $ drush sql-sync @yoursite.dev @yoursite.local
 *   To copy your local database to the development site:
 *   $ drush sql-sync @yoursite.local @yoursite.dev -structure-tables-key=common --no-ordered-dump --sanitize=0 --no-cache
 *   To copy the production database to your local site:
 *   $ drush sql-sync @yoursite.prod @yoursite.local
 *   To copy all files in development site to your local site:
 *   $ drush rsync @yoursite.dev:%files @yoursite.local:%files
 *   Clear the cache in production:
 *   $ drush @yoursite.prod clear-cache all
 *
 * You can copy the site alias configuration of an existing site into a file
 * with the following commands:
 *   $ cd /path/to/settings.php/of/the/site/
 *   $ drush site-alias @self --full --with-optional >> ~/.drush/mysite.aliases.drushrc.php
 * Then edit that file to wrap the code in <?php ?> tags.
 */

/**
 * Local alias
 * Set the root and site_path values to point to your local site
 */
$aliases['local'] = array(
  'root' => '@local_doc',
  'uri'  => '@local_url',
  'path-aliases' => array(
    '%dump-dir' => '/tmp',
  ),
);

/**
 * Development alias
 * Set up each entry to suit your site configuration
 */
$aliases['int'] = array (
  'uri' => '@dev_url',
  'root' => '@dev_doc',
  'remote-user' => '@dev_ssh',
  'remote-host' => '@dev_host',
 // 'ssh-options'  => '-p 2222',  // To change the default port on remote server
  'path-aliases' => array(
    '%dump-dir' => '/tmp',
  ),
  'source-command-specific' => array (
    'sql-sync' => array (
      'no-cache' => TRUE,
      'structure-tables-key' => 'common',
    ),
  ),
  // No need to modify the following settings
  'command-specific' => array (
    'sql-sync' => array (
      'sanitize' => TRUE,
      'no-ordered-dump' => TRUE,
      'structure-tables' => array(
       // You can add more tables which contain data to be ignored by the database dump
        'common' => array('cache', 'cache_filter', 'cache_menu', 'cache_page', 'history', 'sessions', 'watchdog'),
      ),
    ),
  ),
);

?>
