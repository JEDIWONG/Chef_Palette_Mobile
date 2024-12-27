import pygame
import sys

# Initialize Pygame
pygame.init()

# Constants
SCREEN_WIDTH, SCREEN_HEIGHT = 800, 600
FPS = 60

# Setup screen
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
pygame.display.set_caption("Platformer Game")
clock = pygame.time.Clock()

# Main loop
def main():
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
        
        screen.fill((135, 206, 235))  # Sky-blue background
        pygame.display.flip()
        clock.tick(FPS)

if __name__ == "__main__":
    main()

class Player(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.image = pygame.Surface((40, 60))
        self.image.fill((255, 0, 0))  # Red rectangle
        self.rect = self.image.get_rect(center=(SCREEN_WIDTH//2, SCREEN_HEIGHT//2))
        self.velocity = pygame.math.Vector2(0, 0)
        self.on_ground = False

    def update(self, keys):
        # Movement
        self.velocity.x = 0
        if keys[pygame.K_LEFT]:
            self.velocity.x = -5
        if keys[pygame.K_RIGHT]:
            self.velocity.x = 5

        # Gravity
        self.velocity.y += 0.5
        if self.on_ground:
            if keys[pygame.K_SPACE]:  # Jump
                self.velocity.y = -10

        # Update position
        self.rect.x += self.velocity.x
        self.rect.y += self.velocity.y

        # Check if on the ground
        if self.rect.bottom >= SCREEN_HEIGHT:
            self.rect.bottom = SCREEN_HEIGHT
            self.on_ground = True
        else:
            self.on_ground = False

class Platform(pygame.sprite.Sprite):
    def __init__(self, x, y, width, height):
        super().__init__()
        self.image = pygame.Surface((width, height))
        self.image.fill((0, 255, 0))  # Green platform
        self.rect = self.image.get_rect(topleft=(x, y))


player = Player()
platforms = pygame.sprite.Group()
platforms.add(Platform(200, 500, 400, 20))

all_sprites = pygame.sprite.Group(player, *platforms)

def main():
    while True:
        keys = pygame.key.get_pressed()

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

        # Update
        all_sprites.update()
        player.update(keys)

        # Collision
        for platform in platforms:
            if player.rect.colliderect(platform.rect) and player.velocity.y > 0:
                player.rect.bottom = platform.rect.top
                player.on_ground = True
                player.velocity.y = 0

        # Draw
        screen.fill((135, 206, 235))
        all_sprites.draw(screen)
        pygame.display.flip()
        clock.tick(FPS)

if __name__ == "__main__":
    main()
