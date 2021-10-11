<?php
declare(strict_types=1);

namespace Tests\UnitTests;

class NullTest extends \PHPUnit\Framework\TestCase
{
    public function testNothing(): void
    {
        $this->assertNull(null);
    }
}
