<?php
declare(strict_types=1);

namespace Tests\HttpApiTests;

class WelcomeTest extends \PHPUnit\Framework\TestCase
{
    public function getHttpTestsEndpoint(): string
    {
        if (!isset($_ENV['HTTP_TESTS_ENDPOINT']) || $_ENV['HTTP_TESTS_ENDPOINT'] === '') {
            throw new \Exception('HTTP tests endpoint is not defined.');
        }
        return $_ENV['HTTP_TESTS_ENDPOINT'];
    }

    public function testWelcomeMessage(): void
    {
        $client = new \GuzzleHttp\Client();

        $response = $client->request('GET', $this->getHttpTestsEndpoint());

        $this->assertEquals(200, $response->getStatusCode());
        $this->assertEquals('application/json', array_shift($response->getHeader('Content-Type')));
        $payload = json_decode($response->getBody()->getContents(), true);
        $this->assertEquals('Hello world!', $payload['message']);
    }
}
