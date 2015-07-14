package dpsink

import (
	"errors"
	"testing"
	"time"

	"github.com/signalfx/golib/datapoint"
	"github.com/signalfx/golib/event"
	"github.com/signalfx/metricproxy/dp/dptest"
	"github.com/stretchr/testify/assert"
	"golang.org/x/net/context"
)

const numTests = 7

func TestCounterSink(t *testing.T) {
	dps := []*datapoint.Datapoint{
		{},
		{},
	}
	ctx := context.Background()
	bs := dptest.NewBasicSink()
	count := &Counter{}
	middleSink := NextWrap(count)(bs)
	go func() {
		// Allow time for us to get in the middle of a call
		time.Sleep(time.Millisecond)
		assert.Equal(t, int64(1), count.CallsInFlight, "After a sleep, should be in flight")
		datas := <-bs.PointsChan
		assert.Equal(t, 2, len(datas), "Original datas should be sent")
	}()
	middleSink.AddDatapoints(ctx, dps)
	assert.Equal(t, int64(0), count.CallsInFlight, "Call is finished")
	assert.Equal(t, int64(0), count.TotalProcessErrors, "No errors so far (see above)")
	assert.Equal(t, numTests, len(count.Stats(map[string]string{})), "Just checking stats len()")

	bs.RetError(errors.New("nope"))
	middleSink.AddDatapoints(ctx, dps)
	assert.Equal(t, int64(1), count.TotalProcessErrors, "Error should be sent through")
}

func TestCounterSinkEvent(t *testing.T) {
	es := []*event.Event{
		{},
		{},
	}
	ctx := context.Background()
	bs := dptest.NewBasicSink()
	count := &Counter{}
	middleSink := NextWrap(count)(bs)
	go func() {
		// Allow time for us to get in the middle of a call
		time.Sleep(time.Millisecond)
		assert.Equal(t, int64(1), count.CallsInFlight, "After a sleep, should be in flight")
		datas := <-bs.EventsChan
		assert.Equal(t, 2, len(datas), "Original datas should be sent")
	}()
	middleSink.AddEvents(ctx, es)
	assert.Equal(t, int64(0), count.CallsInFlight, "Call is finished")
	assert.Equal(t, int64(0), count.TotalProcessErrors, "No errors so far (see above)")
	assert.Equal(t, numTests, len(count.Stats(map[string]string{})), "Just checking stats len()")

	bs.RetError(errors.New("nope"))
	middleSink.AddEvents(ctx, es)
	assert.Equal(t, int64(1), count.TotalProcessErrors, "Error should be sent through")
}
