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
// package com.dropbox.android.external.store4

import 'package:repostore/src/store.dart';

/**
 * Holder for responses from Store.
 *
 * Instead of using regular error channels (a.k.a. throwing exceptions), Store uses this holder
 * class to represent each response. This allows the flow to keep running even if an error happens
 * so that if there is an observable single source of truth, application can keep observing it.
 */
// sealed class StoreResponse<out T> {
//     /**
//      * Represents the source of the Response.
//      */
//     abstract val origin: ResponseOrigin

//     /**
//      * Loading event dispatched by [Store] to signal the [Fetcher] is in progress.
//      */
//     data class Loading(override val origin: ResponseOrigin) : StoreResponse<Nothing>()

//     /**
//      * Data dispatched by [Store]
//      */
//     data class Data<T>(val value: T, override val origin: ResponseOrigin) : StoreResponse<T>()

//     /**
//      * No new data event dispatched by Store to signal the [Fetcher] returned no data (i.e the
//      * returned [kotlinx.coroutines.Flow], when collected, was empty).
//      */
//     data class NoNewData(override val origin: ResponseOrigin) : StoreResponse<Nothing>()

//     /**
//      * Error dispatched by a pipeline
//      */
//     sealed class Error : StoreResponse<Nothing>() {
//         data class Exception(
//             val error: Throwable,
//             override val origin: ResponseOrigin
//         ) : Error()

//         data class Message(
//             val message: String,
//             override val origin: ResponseOrigin
//         ) : Error()
//     }

//     /**
//      * Returns the available data or throws [NullPointerException] if there is no data.
//      */
//     T requireData() {
//       if (this is Data)
//       {
//         return value;
//       }

//       if (this is Error) {
//         this.doThrow();
//       }

//       throw NullPointerException("there is no data in $this")
// ;
//         // return when (this) {
//         //     is Data -> value
//         //     is Error -> this.doThrow()
//         //     else -> throw NullPointerException("there is no data in $this")
//         // }
//     }

//     //     fun requireData(): T {
//     //     return when (this) {
//     //         is Data -> value
//     //         is Error -> this.doThrow()
//     //         else -> throw NullPointerException("there is no data in $this")
//     //     }
//     // }

//     /**
//      * If this [StoreResponse] is of type [StoreResponse.Error], throws the exception
//      * Otherwise, does nothing.
//      */
//     void throwIfError() {
//         if (this is Error) {
//             this.doThrow();
//         }
//     }

//     // fun throwIfError() {
//     //     if (this is Error) {
//     //         this.doThrow()
//     //     }
//     // }

//     /**
//      * If this [StoreResponse] is of type [StoreResponse.Error], returns the available error
//      * from it. Otherwise, returns `null`.
//      */
//     fun errorMessageOrNull(): String? {
//         return when (this) {
//             is Error.Message -> message
//             is Error.Exception -> error.localizedMessage ?: "exception: ${error.javaClass}"
//             else -> null
//         }
//     }

//     /**
//      * If there is data available, returns it; otherwise returns null.
//      */
//     fun dataOrNull(): T? = when (this) {
//         is Data -> value
//         else -> null
//     }

//     @Suppress("UNCHECKED_CAST")
//     internal fun <R> swapType(): StoreResponse<R> = when (this) {
//         is Error -> this
//         is Loading -> this
//         is NoNewData -> this
//         is Data -> throw RuntimeException("cannot swap type for StoreResponse.Data")
//     }
// }

class StoreResponse<T> {
  /**
     * Represents the source of the Response.
     */
  // abstract val origin: ResponseOrigin
  late final ResponseOrigin origin;

  StoreResponse._();

  factory StoreResponse.data(T value, ResponseOrigin origin) = Data;
  factory StoreResponse.error() = Error;

  /**
     * Returns the available data or throws [NullPointerException] if there is no data.
     */
  T requireData() {
    if (this is Data) {
      return (this as Data).value;
    }

    if (this is Error) {
      (this as Error).doThrow();
    }

    // throw NullPointerException("there is no data in $this");
    throw "there is no data in $this";
    // return when (this) {
    //     is Data -> value
    //     is Error -> this.doThrow()
    //     else -> throw NullPointerException("there is no data in $this")
    // }
  }

  //     fun requireData(): T {
  //     return when (this) {
  //         is Data -> value
  //         is Error -> this.doThrow()
  //         else -> throw NullPointerException("there is no data in $this")
  //     }
  // }

  /**
     * If this [StoreResponse] is of type [StoreResponse.Error], throws the exception
     * Otherwise, does nothing.
     */
  void throwIfError() {
    if (this is Error) {
      (this as Error).doThrow();
    }
  }

  // fun throwIfError() {
  //     if (this is Error) {
  //         this.doThrow()
  //     }
  // }

  /**
     * If this [StoreResponse] is of type [StoreResponse.Error], returns the available error
     * from it. Otherwise, returns `null`.
     */
  String? errorMessageOrNull() {
    if (this is Message) {
      return (this as Message).message;
    }

    if (this is Exception) {
      return (this as Exception).error;
    }

    return null;
    // return when (this) {
    //     is Error.Message -> message
    //     is Error.Exception -> error.localizedMessage ?: "exception: ${error.javaClass}"
    //     else -> null
    // }
  }
  // fun errorMessageOrNull(): String? {
  //     return when (this) {
  //         is Error.Message -> message
  //         is Error.Exception -> error.localizedMessage ?: "exception: ${error.javaClass}"
  //         else -> null
  //     }
  // }

  /**
     * If there is data available, returns it; otherwise returns null.
     */
  T? dataOrNull() {
    if (this is Data) {
      return (this as Data).value;
    }

    return null;
  }
  // fun dataOrNull(): T? = when (this) {
  //     is Data -> value
  //     else -> null
  // }

  // @Suppress("UNCHECKED_CAST")
  // internal fun <R> swapType(): StoreResponse<R> = when (this) {
  //     is Error -> this
  //     is Loading -> this
  //     is NoNewData -> this
  //     is Data -> throw RuntimeException("cannot swap type for StoreResponse.Data")
  // }

  // @Suppress("UNCHECKED_CAST")
  StoreResponse<R> swapType<R>() {
    if (this is Data) {
      // return throw RuntimeException("cannot swap type for StoreResponse.Data");
      return throw "cannot swap type for StoreResponse.Data";
    }

    return this as StoreResponse<R>;
    // if (this
    //   is Error)
    //   return  this
    //   is Loading -> this
    //   is NoNewData -> this
  }
}

/**
     * Loading event dispatched by [Store] to signal the [Fetcher] is in progress.
     */
class Loading extends StoreResponse<Null> {
  @override
  final ResponseOrigin origin;

  Loading(this.origin) : super._();
}

/**
     * Data dispatched by [Store]
     */
// data class Data<T>(val value: T, override val origin: ResponseOrigin) : StoreResponse<T>()
class Data<T> extends StoreResponse<T> {
  final T value;
  final ResponseOrigin origin;

  Data(this.value, this.origin) : super._();
}

/**
     * No new data event dispatched by Store to signal the [Fetcher] returned no data (i.e the
     * returned [kotlinx.coroutines.Flow], when collected, was empty).
     */
// data class NoNewData(override val origin: ResponseOrigin) : StoreResponse<Nothing>()
class NoNewData extends StoreResponse<Null> {
  final ResponseOrigin origin;

  NoNewData(this.origin) : super._();
}

/**
     * Error dispatched by a pipeline
     */
// sealed class Error : StoreResponse<Nothing>() {
//     data class Exception(
//         val error: Throwable,
//         override val origin: ResponseOrigin
//     ) : Error()

//     data class Message(
//         val message: String,
//         override val origin: ResponseOrigin
//     ) : Error()
// }

class Error<T> extends StoreResponse<T> {
  Error() : super._();

  // Error._(): super._();

  factory Error.exception(String error, ResponseOrigin origin) = Exception;
  factory Error.message(String message, ResponseOrigin origin) = Message;
}

class Exception<T> extends Error<T> {
  final String error;
  final ResponseOrigin origin;

  Exception(this.error, this.origin);
}

class Message<T> extends Error<T> {
  final String message;

  final ResponseOrigin origin;
  Message(this.message, this.origin);
}

/**
 * Represents the origin for a [StoreResponse].
 */
enum ResponseOrigin {
  /**
     * [StoreResponse] is sent from the cache
     */
  cache,

  /**
     * [StoreResponse] is sent from the persister
     */
  sourceOfTruth,

  /**
     * [StoreResponse] is sent from a fetcher,
     */
  fetcher
}

extension on Error {
  void doThrow() {
    if (this is Exception) {
      throw (this as Exception).error;
    }

    if (this is Message) {
      // throw RuntimeException(this.message);
      throw (this as Message).message;
    }
  }
}
