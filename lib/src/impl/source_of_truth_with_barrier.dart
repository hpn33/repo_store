/*
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// package com.dropbox.android.external.store4.impl

// import com.dropbox.android.external.store4.ResponseOrigin
// import com.dropbox.android.external.store4.SourceOfTruth
// import com.dropbox.android.external.store4.StoreResponse
// import com.dropbox.android.external.store4.impl.operators.mapIndexed
// import kotlinx.coroutines.CancellationException
// import kotlinx.coroutines.CompletableDeferred
// import kotlinx.coroutines.ExperimentalCoroutinesApi
// import kotlinx.coroutines.flow.Flow
// import kotlinx.coroutines.flow.MutableStateFlow
// import kotlinx.coroutines.flow.catch
// import kotlinx.coroutines.flow.emitAll
// import kotlinx.coroutines.flow.flatMapLatest
// import kotlinx.coroutines.flow.flow
// import kotlinx.coroutines.flow.flowOf
// import kotlinx.coroutines.flow.onStart
// import java.util.concurrent.atomic.AtomicLong

// /**
//  * Wraps a [SourceOfTruth] and blocks reads while a write is in progress.
//  *
//  * Used in the [com.dropbox.android.external.store4.impl.RealStore] implementation to avoid
//  * dispatching values to downstream while a write is in progress.
//  */
// @OptIn(ExperimentalCoroutinesApi::class)
import '../source_of_truth.dart';
import '../store_response.dart';
import 'ref_counted_resource.dart';

class SourceOfTruthWithBarrier<Key, Input, Output>{

    final SourceOfTruth<Key, Input, Output> _delegate;

  SourceOfTruthWithBarrier({
    required SourceOfTruth<Key, Input, Output> delegate,
}) : _delegate = delegate;
    // /**
    //  * Each key has a barrier so that we can block reads while writing.
    //  */
    final _barriers = RefCountedResource<Key, MutableStateFlow<BarrierMsg>>(
        create: () {
            MutableStateFlow(BarrierMsg.Open.INITIAL)
        }
    );
    /**
     * Each message gets dispatched with a version. This ensures we won't accidentally turn on the
     * reader flow for a new reader that happens to have arrived while a write is in progress since
     * that write should be considered as a disk read for that flow, not fetcher.
     */
    final _versionCounter = AtomicLong(0);

    Stream<StoreResponse<Output?>> reader(Key key, CompletableDeferred<void> lock ) {
        // return flow {
        //     final barrier = _barriers.acquire(key);
        //     final readerVersion = _versionCounter.incrementAndGet();
        //     try {
        //         lock.await()
        //         emitAll(
        //             barrier
        //                 .flatMapLatest {
        //                     val messageArrivedAfterMe = readerVersion < it.version
        //                     val writeError = if (messageArrivedAfterMe && it is BarrierMsg.Open) {
        //                         it.writeError
        //                     } else {
        //                         null
        //                     }
        //                     val readFlow: Flow<StoreResponse<Output?>> = when (it) {
        //                         is BarrierMsg.Open ->
        //                             delegate.reader(key).mapIndexed { index, output ->
        //                                 if (index == 0 && messageArrivedAfterMe) {
        //                                     val firstMsgOrigin = if (writeError == null) {
        //                                         // restarted barrier without an error means write succeeded
        //                                         ResponseOrigin.Fetcher
        //                                     } else {
        //                                         // when a write fails, we still get a new reader because
        //                                         // we've disabled the previous reader before starting the
        //                                         // write operation. But since write has failed, we should
        //                                         // use the SourceOfTruth as the origin
        //                                         ResponseOrigin.SourceOfTruth
        //                                     }
        //                                     StoreResponse.Data(
        //                                         origin = firstMsgOrigin,
        //                                         value = output
        //                                     )
        //                                 } else {
        //                                     StoreResponse.Data(
        //                                         origin = ResponseOrigin.SourceOfTruth,
        //                                         value = output
        //                                     ) as StoreResponse<Output?> // necessary cast for catch block
        //                                 }
        //                             }.catch { throwable ->
        //                                 this.emit(
        //                                     StoreResponse.Error.Exception(
        //                                         error = SourceOfTruth.ReadException(
        //                                             key = key,
        //                                             cause = throwable
        //                                         ),
        //                                         origin = ResponseOrigin.SourceOfTruth
        //                                     )
        //                                 )
        //                             }
        //                         is BarrierMsg.Blocked -> {
        //                             flowOf()
        //                         }
        //                     }
        //                     readFlow
        //                         .onStart {
        //                             // if we have a pending error, make sure to dispatch it first.
        //                             if (writeError != null) {
        //                                 emit(
        //                                     StoreResponse.Error.Exception(
        //                                         origin = ResponseOrigin.SourceOfTruth,
        //                                         error = writeError
        //                                     )
        //                                 )
        //                             }
        //                         }
        //                 }
        //         )
        //     } finally {
        //         // we are using a finally here instead of onCompletion as there might be a
        //         // possibility where flow gets cancelled right before `emitAll`.
        //         barriers.release(key, barrier)
        //     }
        // }
    }

    Future <void>  write(Key key ,Input  value ) {
        final barrier = _barriers.acquire(key);
        try {
            barrier.emit(BarrierMsg.Blocked(versionCounter.incrementAndGet()))
            val writeError = try {
                delegate.write(key, value)
                null
            } catch (throwable: Throwable) {
                if (throwable !is CancellationException) {
                    throwable
                } else {
                    null
                }
            }

            barrier.emit(
                BarrierMsg.Open(
                    version = versionCounter.incrementAndGet(),
                    writeError = writeError?.let {
                        SourceOfTruth.WriteException(
                            key = key,
                            value = value,
                            cause = writeError
                        )
                    }
                )
            )
            if (writeError is CancellationException) {
                // only throw if it failed because of cancelation.
                // otherwise, we take care of letting downstream know that there was a write error
                throw writeError
            }
        } finally {
            _barriers.release(key, barrier);
        }
    }

    Future<void> delete(Key key) => _delegate.delete(key);

    Future<void> deleteAll() => _delegate.deleteAll();


    // visible for testing
    Future  barrierCount() => _barriers.size();

    // companion object {
        static const   INITIAL_VERSION = -1.0;
    // }
}


     class BarrierMsg{
final double version;

BarrierMsg  (
       this.version
    ) ;

factory BarrierMsg.blocked(double version) => Blocked;
factory BarrierMsg.open(double version) => Open;
    
    }

        class Blocked extends BarrierMsg {

           Blocked(double version): super(version);
        }

        class Open extends BarrierMsg {
          final String? writeError;

Open(double version, [this. writeError]) : super(version);
            // companion object {
static final INITIAL = Open(SourceOfTruthWithBarrier.INITIAL_VERSION);
            // }
        }
