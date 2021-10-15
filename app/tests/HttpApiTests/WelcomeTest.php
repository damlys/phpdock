<?php
declare(strict_types=1);

namespace Tests\HttpApiTests;

class WelcomeTest extends \PHPUnit\Framework\TestCase
{
    protected function getHttpApiTestsEntrypoint(): string
    {
        if (!isset($_ENV['HTTP_API_TESTS_ENTRYPOINT']) || !$_ENV['HTTP_API_TESTS_ENTRYPOINT']) {
            throw new \Exception('HTTP API tests entrypoint is not defined.');
        }
        return $_ENV['HTTP_API_TESTS_ENTRYPOINT'];
    }

    public function testWelcomeMessage(): void
    {
        $client = new \GuzzleHttp\Client();

        $response = $client->request('GET', $this->getHttpApiTestsEntrypoint());
        $payload = json_decode($response->getBody()->getContents(), true);

        $this->assertEquals(200, $response->getStatusCode());
        $this->assertEquals('application/json', array_shift($response->getHeader('Content-Type')));
        $this->assertEquals('Hello world!', $payload['message']);
    }
}
