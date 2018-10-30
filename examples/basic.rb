#!/usr/bin/env ruby

require 'bundler/setup'
require 'analog/reshaper'

# The shaping factors are used to "reshape" the curve.
# factors = {
#     1..1       => [1],
#     0.9...1    => [1.5, 2.0, 2.5],
#     0.8...0.9  => [1.5, 2.0, 2.5],
#     0.7...0.8  => [1.5, 2.0, 2.5],
#     0.6...0.7  => [1.5, 2.0, 2.5],
#     0.5...0.6  => [1.5, 2.0, 2.5],
#     0.4...0.5  => [1.5, 2.0, 2.5],
#     0.3...0.4  => [1.5, 2.0, 2.5],
#     0.2...0.3  => [1.5, 2.0, 2.5],
#     0.1...0.2  => [1.5, 2.0, 2.5],
#     0.0...0.1  => [1.5, 2.0, 2.5],
# }
#
# puts Scale.transform(0.0).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.1).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.15).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.2).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.25).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.3).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.35).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.4).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.45).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.5).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.55).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.6).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.65).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.7).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.75).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.8).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.85).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.9).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(0.95).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
# puts Scale.transform(1.0).reshape(reshaper).using((0.0)..(1.0), 0..500_000_000_000.0)
