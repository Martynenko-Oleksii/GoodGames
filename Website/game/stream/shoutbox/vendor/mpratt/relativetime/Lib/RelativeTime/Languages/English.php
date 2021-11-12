<?php
/**
 * English.php
 *
 * @author  Michael Pratt <pratt@hablarmierda.net>
 * @link    http://www.michael-pratt.com/
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 */

namespace RelativeTime\Languages;

/**
 * English Translation
 */
class English extends \RelativeTime\Adapters\Language
{
    protected $strings = array(
        'now' => 'Прямо сейчас',
        'ago' => '%s назад',
        'left' => '%s прошло',
        'seconds' => array(
            'plural' => '%d секунд',
            'singular' => '%d секунда',
        ),
        'minutes' => array(
            'plural' => '%d минут',
            'singular' => '%d минута',
        ),
        'hours' => array(
            'plural' => '%d часов',
            'singular' => '%d час',
        ),
        'days' => array(
            'plural' => '%d дней',
            'singular' => '%d день',
        ),
        'months' => array(
            'plural' => '%d месяцев',
            'singular' => '%d месяц',
        ),
        'years' => array(
            'plural' => '%d лет',
            'singular' => '%d год',
        ),
    );
}

?>
