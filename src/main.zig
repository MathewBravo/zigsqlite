const std = @import("std");
const commands = @import("commands.zig");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();

    while (true) {
        var buffer: [1024]u8 = undefined;
        print_prompt();
        const user_input = try stdin.readUntilDelimiter(&buffer, '\n');

        try commands.command_handler(user_input);
    }
}

fn print_prompt() void {
    std.debug.print("> ", .{});
}
