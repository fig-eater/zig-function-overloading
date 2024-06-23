// Created by fig / fig-eater / groakgames.
// https://github.com/fig-eater/zig-function-overloading
//
// This file is licensed under Unlicense
// See included LICENSE file or https://unlicense.org
// Attribution is appreciated but not required.

// Example where we make a init function for the Rect2 Struct
// that acts like an explicitly overloaded function.

const std = @import("std");
const overloading = @import("overloading");

const Vec2 = struct { x: f32 = 0.0, y: f32 = 0.0 };
const Vec2i = struct { x: i32 = 0, y: i32 = 0 };
const Rect2i = struct { position: Vec2i = .{}, size: Vec2i = .{} };
const Rect2 = struct {
    position: Vec2 = .{},
    size: Vec2 = .{},

    const init = overloading.make(.{
        initRect2_0, // void
        initRect2_1, // from: Rect2
        initRect2_2, // from: Rect2i
        initRect2_3, // position: Vec2, size: Vec2
        initRect2_4, // x: f32, y: f32, w: f32, h: f32
        initRect5,
    });

    pub fn print(self: @This()) void {
        std.debug.print("position: ({d},{d})    width:{d} height:{d}\n", .{
            self.position.x,
            self.position.y,
            self.size.x,
            self.size.y,
        });
    }
};

fn initRect2_0() Rect2 {
    return .{};
}

fn initRect2_1(from: Rect2) Rect2 {
    return .{ .position = from.position, .size = from.size };
}

fn initRect2_2(from: Rect2i) Rect2 {
    return .{
        .position = .{ .x = @floatFromInt(from.position.x), .y = @floatFromInt(from.position.y) },
        .size = .{ .x = @floatFromInt(from.size.x), .y = @floatFromInt(from.size.y) },
    };
}

fn initRect2_3(position: Vec2, size: Vec2) Rect2 {
    return .{
        .position = position,
        .size = size,
    };
}

fn initRect2_4(x: f32, y: f32, w: f32, h: f32) Rect2 {
    return .{
        .position = .{ .x = x, .y = y },
        .size = .{ .x = w, .y = h },
    };
}

fn initRect5(s: []const u8) Rect2 {
    if (s.len < 4) {
        return .{};
    }
    return .{
        .position = .{ .x = @floatFromInt(s[0]), .y = @floatFromInt(s[1]) },
        .size = .{ .x = @floatFromInt(s[2]), .y = @floatFromInt(s[3]) },
    };
}

pub fn main() !void {
    const some_rect2 = Rect2{
        .position = .{ .x = 0.0, .y = 1.0 },
        .size = .{ .x = 2.0, .y = 3.0 },
    };
    const some_rect2i = Rect2i{
        .position = .{ .x = 4, .y = 5 },
        .size = .{ .x = 6, .y = 7 },
    };
    const some_vec2a = Vec2{ .x = 8, .y = 9 };
    const some_vec2b = Vec2{ .x = 8, .y = 9 };
    Rect2.init({}).print(); // calling init with no args
    Rect2.init(some_rect2).print(); // calling init with rect2
    Rect2.init(some_rect2i).print(); // calling init with rect2i
    Rect2.init(.{ some_vec2a, some_vec2b }).print(); // calling init with Vec2, Vec2
    Rect2.init(.{ 12.0, 13.0, 14.0, 15.0 }).print(); // calling init with f32s, f32s, f32s, f32s
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const str = try std.fmt.allocPrint(allocator, "\x04\x03\x02\x01", .{});
    defer allocator.free(str);

    Rect2.init(str).print();
    Rect2.init("test").print();
    // const C = struct {
    //     a: u32 = 0,
    // };
    const ExternC = extern struct {
        a: u32 = 0,
    };
    const ptr: [*c]const ExternC = &.{};

    std.debug.print("{any}\n", .{@typeInfo(@TypeOf(ptr))});

    // Rect2.init(@constCast("test")).print();
}
