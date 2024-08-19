// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

const Player = struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    facing: rl.Vector2,
    thrust: f32,
    thrusting: bool,
};

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const initialScreenWidth = 800;
    const initialScreenHeight = 450;

    const colorSpace = rl.Color.init(0, 0, 50, 255);

    var player = Player{
        .position = .{ .x = initialScreenWidth / 2, .y = initialScreenHeight / 2 },
        .velocity = .{ .x = 0, .y = 0 },
        .facing = .{ .x = 0, .y = -1 },
        .thrust = 100,
        .thrusting = false,
    };

    rl.initWindow(initialScreenWidth, initialScreenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context
    // rl.setExitKey(.key_null);

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        const delta = rl.getFrameTime();

        // Update
        //----------------------------------------------------------------------------------
        var playerAcceleration = rl.Vector2{ .x = 0, .y = 0 };

        if (rl.isKeyDown(.key_up)) {
            player.thrusting = true;
        } else {
            player.thrusting = false;
        }

        if (rl.isKeyDown(.key_down)) {}
        if (rl.isKeyDown(.key_left)) {
            player.facing = rl.math.vector2Rotate(player.facing, -5 * delta);
        }
        if (rl.isKeyDown(.key_right)) {
            player.facing = rl.math.vector2Rotate(player.facing, 5 * delta);
        }

        // Update player velocity with acceleration and drag
        if (player.thrusting) {
            playerAcceleration = rl.math.vector2Add(playerAcceleration, rl.math.vector2Scale(player.facing, player.thrust * delta));
        }
        player.velocity = rl.math.vector2Add(player.velocity, playerAcceleration);
        player.velocity = rl.math.vector2Scale(player.velocity, 1 - (0.2 * delta));

        // Update player position with velocity
        player.position = rl.math.vector2Add(player.position, rl.math.vector2Scale(player.velocity, delta));

        // player wraps to other side of screen when out of bounds.
        const screenWidth: f32 = @floatFromInt(rl.getScreenWidth());
        const screenHeight: f32 = @floatFromInt(rl.getScreenHeight());

        player.position.x = @mod(player.position.x, screenWidth);
        player.position.y = @mod(player.position.y, screenHeight);

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(colorSpace);

        // draw player
        rl.drawCircleV(player.position, 10, if (player.thrusting) rl.Color.blue else rl.Color.yellow);
        rl.drawCircleV(player.position, 3, rl.Color.red);
        const lineEnd = rl.math.vector2Add(player.position, rl.math.vector2Scale(player.facing, 10));
        rl.drawLineEx(player.position, lineEnd, 2, rl.Color.black);

        //----------------------------------------------------------------------------------
    }
}
