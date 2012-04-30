define(["common/EventEmitter"],
(EventEmitter) ->
# TODO: extend backbone model so we can enable/disable menu items appropriately.
# TODO: just make a damned JS linked list implementation...  this would be so much less hacky!
	class UndoHistory
		constructor: (@size) ->
			@actions = new Array(@size)
			@cursor = -1
			@start = 0
			@end = 0
			@cnt = 0
			_.extend(@, new EventEmitter())

		push: (action) ->
			++@cnt
			@undoEnd = false
			prevCursor = @cursor
			@cursor = (@cursor + 1) % @size
			@end = @cursor + 1
			if @cnt >= @size
				@start = @end % @size

			@actions[@cursor] = action

		undo: () ->
			if @cursor is @start
				if not @undoEnd
					@actions[@cursor].undo()
					@undoEnd = true
			else if @cursor isnt -1
				@actions[@cursor].undo()
				--@cursor
				if @cursor < 0
					@cursor = @actions.length - 1


		redo: () ->
			tempCursor = (@cursor + 1) % @size
			if tempCursor isnt @end
				@cursor = tempCursor
				@actions[@cursor].do()
			else if @undoEnd
				@actions[@cursor].do()
				@undoEnd = false


		# this'll be way easier / make way more sense
		class UndoHistory2 extends LinkedList

)