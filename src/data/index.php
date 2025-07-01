<?php

declare(strict_types=1);

function adminer_object(): object
{
    include_once __DIR__ . "/plugins/login-password-less.php";

    class AdminerCustomization extends Adminer\Plugins
    {
        const DEFAULT_PASSWORD = 'DEFAULT_PASSWORD';

        public function name(): ?string
        {
            return $this->getEnv('ADMINER_NAME') ?? parent::name();
        }

        public function loginForm(): void
        {
            parent::loginForm();

            if ($this->getEnv('ADMINER_AUTOLOGIN')) {
                echo "<script " . Adminer\nonce() . ">
                    if (document.querySelector('#content > div.error') == null) {
                        document.addEventListener('DOMContentLoaded', function () {
                            document.forms[0].submit()
                        })
                    }
                </script>";
            }
        }

        public function loginFormField($name, $heading, $value): string
        {
            $envValue = $this->getLoginConfigValue($name);

            if ($envValue !== null) {
                $value = sprintf(
                    '<input name="auth[%s]" type="%s" value="%s">',
                    Adminer\h($name),
                    Adminer\h($name === 'password' ? 'password' : 'text'),
                    Adminer\h($envValue)
                );
            }

            return parent::loginFormField($name, $heading, $value);
        }

        function database()
        {
            return $this->getEnv('ADMINER_DB');
        }

        private function getLoginConfigValue(string $key): ?string
        {
            return match($key) {
                'db' => $this->getEnv('ADMINER_DB'),
                'driver' => $this->getEnv('ADMINER_DRIVER'),
                'password' => $this->getEnv('ADMINER_PASSWORD', self::DEFAULT_PASSWORD),
                'server' => $this->getEnv('ADMINER_SERVER'),
                'username' => $this->getEnv('ADMINER_USERNAME'),
                'name' => $this->getEnv('ADMINER_NAME'),
                default => null,
            };
        }

        private function getEnv(string $key, ?string $default = null): ?string
        {
            return getenv($key) ?: $default;
        }
    }

    return new AdminerCustomization([
        new AdminerLoginPasswordLess(
            password_hash(getenv('ADMINER_PASSWORD') ?: AdminerCustomization::DEFAULT_PASSWORD , PASSWORD_DEFAULT)
        )
    ]);
}

include __DIR__  . "/adminer.php";